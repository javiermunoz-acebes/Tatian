# Tatian: Parallel Corpus Latin–Old High German

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23598761.svg)](https://doi.org/10.5281/zenodo.23598761)
[![Open in Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/javiermunoz-acebes/Tatian/blob/main/tatian_manos.ipynb)

*[Español más abajo](#español)*

## English

Parallel corpus Latin / Old High German based on Sievers, Eduard (1892): *Tatian. Lateinisch und altdeutsch mit ausführlichem Glossar*. 2nd ed. Paderborn: Schöningh. The corpus follows Sievers' text and his division into chapters and sections: 1,601 sections of the harmony (40,311 Latin and 46,403 Old High German words), followed by 47 rows with short texts that Sievers edits separately, labelled by leaf (e.g. `I Bl. 4b oben, 1`).

### Files

| File | Content |
| --- | --- |
| `Tatian_CorPar.csv` | The corpus (separator `;`). Four columns: Chapter, Latin Text, Old High German Text, Biblical References. |
| `tatian_enlaces.csv` | Word alignment Latin–Old High German (40,062 links), made with eflomal 2.0 and symmetrised with grow-diag-final-and. One row per link: section (`unidad`, `etiqueta`), biblical reference, gospel, and the position, form and normalised form of the Latin and the Old High German word. |
| `masser_aparato_por_pagina.csv` | Counts per codex page of the critical apparatus of Masser (1994): entries, entries naming the corrector, erasures, *ther* < *thie*, and d-/th- substitutions, with quire, scribe and Sievers' chapters for each page. Produced by OCR; the apparatus text itself is not distributed. |
| `tatian_manos.ipynb` | Jupyter / Google Colab notebook that reproduces the study of scribes and translators. It downloads the three CSV files from this repository. |
| `app_tatian_corpus.R` | Shiny application for searching the Latin and Old High German text. |
| `app_tatian_python.py` | Streamlit application for interactive queries on the corpus. |

### Applications and related work

- Online query application: [javiermunoz.shinyapps.io/Tatian_Corpus](https://javiermunoz.shinyapps.io/Tatian_Corpus/) (code: [doi:10.5281/zenodo.23662798](https://doi.org/10.5281/zenodo.23662798)); described in Muñoz-Acebes, F. J. (2026): "From Corpus to Interface" (in press).

### How to cite

Muñoz-Acebes, Francisco Javier / González-Miguel, Ángeles (2026): *Tatian: Parallel Corpus (Latin–Old High German)*, version 1.0.0. Zenodo. https://doi.org/10.5281/zenodo.23598761

### License

CC0 1.0 Universal (see [`LICENSE`](LICENSE)).

---

## Español

Corpus paralelo latín / antiguo alto alemán basado en Sievers, Eduard (1892): *Tatian. Lateinisch und altdeutsch mit ausführlichem Glossar*. 2.ª ed. Paderborn: Schöningh. El corpus reproduce el texto de Sievers y su división en capítulos y secciones: 1.601 secciones de la armonía (40.311 palabras latinas y 46.403 en antiguo alto alemán), seguidas de 47 filas con textos breves que Sievers edita aparte, etiquetadas por hoja (p. ej. `I Bl. 4b oben, 1`).

### Ficheros

| Fichero | Contenido |
| --- | --- |
| `Tatian_CorPar.csv` | El corpus (separador `;`). Cuatro columnas: capítulo, texto latino, texto en antiguo alto alemán y referencia bíblica. |
| `tatian_enlaces.csv` | Alineamiento palabra a palabra latín–antiguo alto alemán (40.062 enlaces), hecho con eflomal 2.0 y simetrizado con grow-diag-final-and. Una fila por enlace: sección (`unidad`, `etiqueta`), referencia bíblica, evangelio y posición, forma y forma normalizada de la palabra latina y de la alemana. |
| `masser_aparato_por_pagina.csv` | Recuento por página del códice del aparato crítico de Masser (1994): entradas, entradas que nombran al corrector, raspados, *ther* < *thie* y sustituciones d-/th-, con el cuaderno, el copista y los capítulos de Sievers de cada página. Obtenido por OCR; no se distribuye el texto del aparato. |
| `tatian_manos.ipynb` | Cuaderno de Jupyter / Google Colab que reproduce el estudio de copistas y traductores. Descarga los tres CSV de este repositorio. |
| `app_tatian_corpus.R` | Aplicación Shiny para buscar en el texto latino y en el alemán. |
| `app_tatian_python.py` | Aplicación Streamlit para consultar el corpus de forma interactiva. |

### Aplicaciones y trabajos relacionados

- Aplicación de consulta en línea: [javiermunoz.shinyapps.io/Tatian_Corpus](https://javiermunoz.shinyapps.io/Tatian_Corpus/) (código: [doi:10.5281/zenodo.23662798](https://doi.org/10.5281/zenodo.23662798)); descrita en Muñoz-Acebes, F. J. (2026): "From Corpus to Interface" (en prensa).

### Cómo citar

Muñoz-Acebes, Francisco Javier / González-Miguel, Ángeles (2026): *Tatian: Parallel Corpus (Latin–Old High German)*, versión 1.0.0. Zenodo. https://doi.org/10.5281/zenodo.23598761

### Licencia

CC0 1.0 Universal (véase [`LICENSE`](LICENSE)).
