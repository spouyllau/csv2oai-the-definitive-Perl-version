# CSV2OAI : Serveur OAI-PMH pour fichier CSV (The definitive Perl version)

Ce projet implémente un serveur **OAI-PMH** minimal en **Perl 5** (🐪 Perl vaincra !), lisant ses données depuis un fichier **CSV** conforme au format _Dublin Core Element Set_. OAI-PMH est un protocol pour l'échange de metadonnées et de données depuis 1999 : voir le site officiel [Open Archives Initiative Protocol for Metadata Harvesting](https://www.openarchives.org/pmh/).

Aussi disponible pour [PHP ≥ 7.2](https://github.com/spouyllau/csv2oai).
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
| `index.html` | Interface HTML de démonstration |
| `oaiperl.png`| Logo |

---

## Structure du fichier `data.csv`

Le fichier CSV doit :

- Être encodé en UTF-8
- Utiliser `;` comme séparateur de colonnes
- Avoir **en première colonne un champ `set`**
- Contenir les **15 éléments Dublin Core** suivants (dans n'importe quel ordre après `set`, `identifier`, `date`) :

```csv
set;identifier_oai;identifier;title;creator;subject;description;publisher;date;type;format;language;coverage;rights;relation;
```

:warning: L'ordre des champs DC peut-être géré à la ligne 180 du fichier oai.pl
---

## Installation

1. Placez les fichiers `oai.pl` et `data.csv` dans votre répertoire `cgi-bin`.

2. Donnez les droits d’exécution :

```bash
chmod +x oai.pl
```

3. **Vous devez adapter à votre serveur la variable $baseURL. Par exemple : my $baseURL = 'https://votreserveurWeb.org/oai-pmh/oai.pl';

4. Accédez à votre serveur à l’URL :

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


## Demo

Un serveur de démonstrateur est maintenu sur <a href="https://www.stephanepouyllau.org/oai-perl/">https://www.stephanepouyllau.org/oai-perl/</a>.

---

## Notes et limitations

- Le script ne dépend **d’aucune bibliothèque externe**.
- Les données sont intégralement extraites depuis `data.csv`.
- La pagination se fait via `resumptionToken`.
- Le script n'implémente pas les fonctionalités de `deleted`, `from`, `until` de l'OAI dans la mesure où il doit rester très léger pour les utilisateurs non spécialiste de l'OAI. Pour celles et ceux qui souhaitent une intégration complète du protocole OAI-PMH, d'autres outils sont disponibles avec une gestion plus fine (Dataverse, Omeka Classic ou S, etc.).
- Ce serveur ne convient pas pour des fichiers csv de taille importante, d'autres outils sont disponibles pour des très grand volume de données (Dataverse, etc.).

---

## Licence et citation

Ce projet est open-source, voir le fichier LICENSE pour plus d'information.

Citation : POUYLLAU, S. (CNRS) with Mistral 7b, _CSV2OAI : Serveur OAI-PMH pour fichier CSV (The definitive Perl version)_, juillet 2025.

---

## Contact

Créé par Stéphane Pouyllau, ingénieur de recherche CNRS. 
Date : juillet 2025.

