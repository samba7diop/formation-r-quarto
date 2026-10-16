# Publication sur GitHub Pages (lecture mobile)

## Objectif

Publier le livre en ligne pour le consulter depuis un téléphone :

```text
https://samba7diop.github.io/formation-r-quarto/
```

## Méthode recommandée — GitHub Actions

Ce projet contient déjà `.github/workflows/publish.yml`.

### 1. Créer le dépôt GitHub

Sur [github.com/new](https://github.com/new) :

- Nom suggéré : `formation-r-quarto`
- Public
- **Sans** README (le projet en a déjà un)

### 2. Pousser le code

Dans PowerShell, depuis `formation-r/` :

```powershell
$env:Path = "C:\Program Files\RStudio\resources\app\bin\quarto\bin;" + $env:Path
cd "C:\Users\Alhamdoulilah\Desktop\LIVRE R\formation-r"

git init
git add .
git commit -m "Livre de formation R et Quarto"

gh repo create formation-r-quarto --public --source=. --remote=origin --push
```

Sans `gh`, après création manuelle du dépôt vide :

```powershell
git remote add origin https://github.com/VOTRE_COMPTE/formation-r-quarto.git
git branch -M main
git push -u origin main
```

### 3. Activer GitHub Pages

1. Dépôt → **Settings** → **Pages**
2. Source : **Deploy from a branch**
3. Branche : **gh-pages** / dossier **/ (root)**
4. Save

Au premier push sur `main`, l’action **Publier sur GitHub Pages** construit le livre et met à jour `gh-pages`.

### 4. Ouvrir sur le téléphone

Attendez que l’action soit verte (onglet **Actions**), puis ouvrez :

```text
https://VOTRE_COMPTE.github.io/formation-r-quarto/
```

## Alternative locale — `quarto publish`

```powershell
$env:Path = "C:\Program Files\RStudio\resources\app\bin\quarto\bin;" + $env:Path
cd "C:\Users\Alhamdoulilah\Desktop\LIVRE R\formation-r"
quarto publish gh-pages
```

## Mise à jour

Chaque `git push` sur `main` republie automatiquement le site.
