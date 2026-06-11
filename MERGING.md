# MERGING.md — Stratégie de Synchronisation Upstream

## Stratégie

- **Cadence :** Toutes les 2 semaines (bi-hebdomadaire)
- **Méthode :** Merge (pas rebase) — `git merge upstream/master` préserve l'historique upstream
- **Auteur :** Manuel — pas d'automatisation CI pour éviter les conflits silencieux

## Architecture des Branches

| Branche | Rôle | Track |
|---------|------|-------|
| `master` | Miroir de `upstream/master` (stable) — reçoit les merges upstream | `upstream/master` |
| `custom` | Contient toutes les modifications du fork (packages, configs, scripts) | `origin/custom` |
| `feature/*` | Branches temporaires par fonctionnalité | Mergées dans `custom` via rebase |

## Procédure de Sync Bi-Hebdomadaire

### 1. Récupérer les changements upstream

```bash
git fetch upstream
```

### 2. Merger upstream/master dans master

```bash
git checkout master
git merge upstream/master --no-edit
```

### 3. Pousser master mise à jour vers le fork

```bash
git push origin master
```

### 4. Rebaser custom sur master

```bash
git checkout custom
git rebase master
```

En cas de conflit pendant le rebase :
- `git status` pour voir les fichiers en conflit
- Résoudre les conflits manuellement (ouvrir les fichiers, chercher `<<<<<<<`)
- `git add <fichier>` pour marquer comme résolu
- `git rebase --continue` pour continuer

### 5. Pousser custom mise à jour

```bash
git push origin custom --force-with-lease
```

> `--force-with-lease` est nécessaire car le rebase réécrit l'historique de `custom`.

## Résolution de Conflits

### Conflits lors du merge upstream/master → master

1. Identifier les fichiers en conflit : `git status`
2. Ouvrir chaque fichier et chercher les marqueurs `<<<<<<<`, `=======`, `>>>>>>>`
3. Pour les conflits dans les zones NON modifiées par le fork (majorité des fichiers) :
   - Accepter la version upstream (garder le code entre `=======` et `>>>>>>>`)
4. Pour les conflits dans les zones modifiées par le fork (`install/`, `default/`) :
   - Fusionner manuellement en préservant les modifications du fork
5. Après résolution : `git add <fichier>` puis `git merge --continue`

### Conflits lors du rebase custom sur master

Même procédure, mais utiliser `git rebase --continue` au lieu de `git merge --continue`.

## Conventions de Messages de Commit

| Contexte | Format | Exemple |
|----------|--------|---------|
| Merge upstream | `merge: upstream/master → master (YYYY-MM-DD)` | `merge: upstream/master → master (2026-06-23)` |
| Modification du fork | `custom: <description>` | `custom: ajout package firefox dans omarchy-base.packages` |
| Feature | `feat(<scope>): <description>` | `feat(kernel): ajout script cachyos-kernel.sh` |
| Infrastructure | `chore: <description>` | `chore: mise à jour .gitignore` |

## Vérification Post-Sync

Après chaque sync, vérifier que rien n'est cassé :

```bash
# Vérifier que les branches sont à jour
git log --oneline master..upstream/master    # Doit être vide (master a tout upstream)
git log --oneline upstream/master..master    # Commits du fork dans master (normalement vide ou minime)

# Vérifier que custom contient bien nos modifications
git diff master..custom -- install/ default/
```
