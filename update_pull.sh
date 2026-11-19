#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd -- "$SCRIPT_DIR"

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
    echo "Erreur : ce script doit être exécuté dans un dépôt Git." >&2
    exit 1
fi

BRANCH="$(git branch --show-current)"
if [[ -z "$BRANCH" ]]; then
    echo "Erreur : impossible de mettre à jour un état HEAD détaché." >&2
    exit 1
fi

if ! UPSTREAM="$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null)"; then
    echo "Erreur : la branche '$BRANCH' n'a pas de branche distante suivie." >&2
    echo "Configurez-la avec : git branch --set-upstream-to=origin/$BRANCH $BRANCH" >&2
    exit 1
fi

STASH_REF=""
if [[ -n "$(git status --porcelain)" ]]; then
    STASH_MESSAGE="update_pull: sauvegarde avant rebase de $BRANCH"
    echo "Sauvegarde des modifications locales (y compris les fichiers non suivis)..."
    git stash push --include-untracked --message "$STASH_MESSAGE" >/dev/null
    STASH_REF="stash@{0}"
fi

restore_stash() {
    if [[ -n "$STASH_REF" ]]; then
        echo "Restauration des modifications locales..."
        if ! git stash pop "$STASH_REF"; then
            echo >&2
            echo "Conflit lors de la restauration des modifications locales." >&2
            echo "Résolvez les conflits, puis supprimez le stash avec :" >&2
            echo "  git stash drop $STASH_REF" >&2
            exit 1
        fi
    fi
}

echo "Récupération de $UPSTREAM..."
git fetch --prune "${UPSTREAM%%/*}"

echo "Rebase de $BRANCH sur $UPSTREAM..."
if ! git rebase "$UPSTREAM"; then
    echo >&2
    echo "Le rebase est en conflit et a été laissé ouvert pour résolution." >&2
    echo "Après résolution : git add <fichiers> && git rebase --continue" >&2
    echo "Pour annuler : git rebase --abort" >&2
    echo "Les modifications locales sauvegardées sont toujours dans : $STASH_REF" >&2
    exit 1
fi

restore_stash

echo
echo "Mise à jour terminée. État du dépôt :"
git status --short --branch