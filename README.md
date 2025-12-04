# OpenActive Modelling Opportunity Data

This repository holds the source for the Modelling Opportunity Data specification developed by the [OpenActive Community Group](https://www.w3.org/community/openactive). Links to the published specifications are provided below.


Thw specification introduces a data model to support the publication of data describing opportunities for people to engage in physical activities ("opportunity data"). This model covers description of activities, as well as the events and locations in which they take place.

The specification is intended to support the publication of opportunity data as open data for anyone to access, use and share. It will also guide reusers of opportunity data, introducing them to the key concepts relevant to that sector.

The model may also be useful in guiding the development of both new and existing booking systems and applications that consume opportunity data.

To contribute to the development of the specification, please [join our community group](https://www.w3.org/community/openactive/)

## Latest versions

* **[Latest Official Version](https://www.openactive.io/modelling-opportunity-data/)** (Candidate Specification)
* **[Current Editors Draft](https://www.openactive.io/modelling-opportunity-data/EditorsDraft/)**

For an introduction to using the specification read the [Publishing Opportunity Data Primer](https://www.openactive.io/opportunity-data-primer/) which contains a number of worked examples.

## Building the specification

The specification has been authored using [the W3C respec tool](https://github.com/w3c/respec) using the markdown syntax option.

The editors draft is the primary working document. Once this has been reviewed and agreed for release, then it can be promoted to be the latest published draft (copied into the `Latest` directory). At which point the publication date should be added to the document.

For live reloading of the document during editing, run `gulp`.

The specification will be automatically deployed following a merge of a pull request into the master branch. This is handled by [Travis](https://travis-ci.org/openactive/modelling-opportunity-data) which will render both versions of the specification to HTML and push them to the `gh-pages` branch of this repo.

