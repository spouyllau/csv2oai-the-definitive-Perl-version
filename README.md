# Perl OAI-PMH Server

Ce projet implémente un serveur **OAI-PMH** (Open Archives Initiative Protocol for Metadata Harvesting) minimal en **Perl 5**, lisant ses données depuis un fichier **CSV** conforme au Dublin Core.

---

## Prérequis

- **Perl ≥ 5.10**
- Modules Perl standards uniquement :
  - `CGI`
  - `POSIX`
- Serveur HTTP compatible CGI (Apache, Nginx avec FCGI, ou serveur local)
- Fichier CSV structuré selon le format _Dublin Core Element Set_

---

## Fichiers du projet

| Fichier        | Description |
|----------------|-------------|
| `oai.pl`       | Script Perl CGI principal (serveur OAI-PMH) |
| `data.csv`     | Base de données CSV contenant les enregistrements Dublin Core |

---

## Structure du fichier `data.csv`

Le fichier CSV doit :

- Être encodé en UTF-8
- Utiliser `;` comme séparateur de colonnes
- Avoir **en première colonne un champ `set`**
- Contenir les **15 éléments Dublin Core** suivants (dans n'importe quel ordre après `set`, `identifier`, `date`) :

```csv
set;identifier;date;title;creator;subject;description;publisher;contributor;type;format;source;language;relation;coverage;rights
```

---

## Installation

1. Placez les fichiers `oai.pl` et `data.csv` dans votre répertoire `cgi-bin`.

2. Donnez les droits d’exécution :

```bash
chmod +x oai.pl
```

3. Accédez à votre serveur à l’URL :

```
http://localhost/cgi-bin/oai.pl?verb=Identify
```

---

## Verbes supportés

| Verbe OAI       | Description |
|------------------|-------------|
| `Identify`        | Informations sur le dépôt |
| `ListMetadataFormats` | Retourne les formats de métadonnées pris en charge |
| `ListIdentifiers`     | Liste les en-têtes des enregistrements |
| `ListRecords`         | Liste complète des enregistrements Dublin Core |
| `GetRecord`           | Récupère un enregistrement spécifique |
| `ListSets`            | Retourne les ensembles disponibles (`setSpec`) |

---

## Exemple d’appel

```http
GET /cgi-bin/oai.pl?verb=ListRecords&metadataPrefix=oai_dc&set=set1
```

---

## Notes

- Le script ne dépend **d’aucune bibliothèque externe**.
- Les données sont intégralement extraites depuis `data.csv`.
- La pagination se fait via `resumptionToken`.
- Le script n'implémente pas les fonctionalités de `deleted`, `from` et `until` de l'OAI dans la mesure où il doit rester très léger pour les utilisateurs non spécialiste de l'OAI. Pour celles et ceux qui souhaitent une intégration complète du protocole OAI-PMH, d'autres outils sont disponibles avec une gestion plus fine (Dataverse, Omeka Classic ou S, etc.)

---

## Contact

Créé par Stéphane Pouyllau, ingénieur de recherche CNRS. 
Date : juillet 2025.

