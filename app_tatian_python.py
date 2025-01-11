import streamlit as st
import pandas as pd
import requests

# URL del archivo CSV
import pandas as pd
import streamlit as st
import requests
from io import StringIO

# Función para cargar los datos desde el CSV en GitHub
@st.cache_data
def load_data():
    url = "https://raw.githubusercontent.com/javiermunoz-acebes/Tatian/main/Tatian_CorPar.csv"
    response = requests.get(url)
    content = response.text
    data = pd.read_csv(StringIO(content), sep=";")  # Aquí se usa StringIO del módulo io
    return data

# Función principal
def main():
    # Cargar los datos
    df = load_data()

    # Título de la app
    st.title("Consulta del Corpus Tatian")

    # Entrada de texto para buscar la palabra
    search_term = st.text_input("Buscar palabra:")

    # Selección de idioma
    language = st.selectbox("Seleccionar idioma:", ["Texto_Latino", "Texto_alto_aleman_antiguo"])

    # Botón para ejecutar la búsqueda
    if st.button("Buscar"):
        # Filtrar los resultados según el término de búsqueda y el idioma
        term = search_term.lower()
        filtered_df = df[df[language].str.contains(term, case=False, na=False)]

        # Mostrar los resultados
        if filtered_df.empty:
            st.write("No se encontraron resultados.")
        else:
            st.write(f"Resultados para '{search_term}' en el idioma seleccionado:")
            st.dataframe(filtered_df)

    # Mostrar estadísticas
    if st.checkbox("Mostrar estadísticas"):
        st.write(f"Número total de registros en el corpus: {len(df)}")
        st.write(f"Número de columnas: {df.shape[1]}")
        st.write(f"Primeras filas del corpus:")
        st.dataframe(df.head())

# Ejecutar la función principal
if __name__ == "__main__":
    main()
