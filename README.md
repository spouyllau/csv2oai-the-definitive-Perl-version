# CSV2OAI: OAI-PMH Server for CSV File (The definitive Perl version)

This project implements a minimal **OAI-PMH** (Open Archives Initiative Protocol for Metadata Harvesting) server in **Perl 5** (🐪 Perl will prevail!), reading its data from a **CSV** file formatted according to the _Dublin Core Element Set_.

---

## Prerequisites

- **Perl ≥ 5.10**
- Only standard Perl modules:
  - `CGI`
  - `POSIX`
- CGI-compatible HTTP server (Apache, Nginx with FCGI, or local server)
- CSV file structured according to the _Dublin Core Element Set_ format

---

## Project Files

| File         | Description |
|--------------|-------------|
| `oai.pl`     | Main Perl CGI script (OAI-PMH server) |
| `data.csv`   | CSV database containing Dublin Core records |
| `index.html` | Query interface |
| `oaiperl.png`| Logo |

---

## Structure of the `data.csv` File

The CSV file must:

- Be UTF-8 encoded
- Use `;` as the column separator
- Have a **`set` field in the first column**
- Contain the following **15 Dublin Core elements** (in any order after `set`, `identifier`, `date`):

```csv
set;identifier_oai;identifier;title;creator;subject;description;publisher;date;type;format;language;coverage;rights;relation;
```

---

## Installation

1. Place the `oai.pl` and `data.csv` files in your `cgi-bin` directory.

2. Make the script executable:

```bash
chmod +x oai.pl
```

3. Access your server at the following URL:

```
http://localhost/cgi-bin/oai.pl?verb=Identify
```

---

## Supported Verbs

| OAI Verb           | Description |
|--------------------|-------------|
| `Identify`         | Information about the repository |
| `ListMetadataFormats` | Returns supported metadata formats |
| `ListIdentifiers`      | Lists record headers |
| `ListRecords`          | Full list of Dublin Core records |
| `GetRecord`            | Retrieves a specific record |
| `ListSets`             | Returns available sets (`setSpec`) |

---

## Example Call

```http
GET /cgi-bin/oai.pl?verb=ListRecords&metadataPrefix=oai_dc&set=set1
```

---

## Demo

A demo is avalaible on <a href="https://www.stephanepouyllau.org/oai-perl/">https://www.stephanepouyllau.org/oai-perl/</a>.

---

## Notes and Limitations

- The script does **not depend on any external libraries**.
- All data is extracted directly from `data.csv`.
- Pagination is handled via `resumptionToken`.
- The script does not implement the `deleted`, `from`, or `until` functionalities of OAI, as it is intended to remain lightweight for users unfamiliar with OAI. For those seeking full OAI-PMH protocol support, other tools provide more advanced handling (Dataverse, Omeka Classic or S, etc.).
- This server is not suitable for large CSV files; other tools are available for handling very large datasets (e.g., Dataverse).

---

## License and Citation

This project is open-source. See the LICENSE file for more information.

Citation: POUYLLAU, S. (CNRS) with Mistral 7b, _CSV2OAI: OAI-PMH Server for CSV File (The definitive Perl version)_, July 2025.

---

## Contact

Created by Stéphane Pouyllau, CNRS research engineer.  
Date: July 2025.