#!/bin/bash	

#Descargamos el archivo
wget https://raw.githubusercontent.com/juanpp94/Proyecto2BaseDeDatosI/master/tablaClientesGrande.csv
wget https://raw.githubusercontent.com/juanpp94/Proyecto2BaseDeDatosI/master/tablaClientesPequena.csv
wget https://raw.githubusercontent.com/juanpp94/Proyecto2BaseDeDatosI/master/tablaCiudadGrande.csv
wget https://raw.githubusercontent.com/juanpp94/Proyecto2BaseDeDatosI/master/tablaCiudadPequena.csv
wget https://raw.githubusercontent.com/juanpp94/Proyecto2BaseDeDatosI/master/tablaClientesGrandeV2.csv
wget https://raw.githubusercontent.com/juanpp94/Proyecto2BaseDeDatosI/master/tablaClientesPequenaV2.csv
wget https://raw.githubusercontent.com/juanpp94/Proyecto2BaseDeDatosI/master/tablaCiudadGrandeV2.csv
wget https://raw.githubusercontent.com/juanpp94/Proyecto2BaseDeDatosI/master/tablaCiudadPequenaV2.csv
wget https://raw.githubusercontent.com/juanpp94/Proyecto2BaseDeDatosI/master/tablaItemGrande.csv
wget https://raw.githubusercontent.com/juanpp94/Proyecto2BaseDeDatosI/master/tablaItemPequena.csv
wget https://raw.githubusercontent.com/juanpp94/Proyecto2BaseDeDatosI/master/tablaItemGrandeV2.csv
wget https://raw.githubusercontent.com/juanpp94/Proyecto2BaseDeDatosI/master/tablaItemPequenaV2.csv


#Movemos el archivo a la carpeta de archivos temporales
cp tablaClientesPequena.csv tablaCiudadGrande tablaClientesGrande tablaCiudadPequena /var/tmp
cp tablaClientesGrandeV2.csv tablaClientesPequenaV2.csv tablaCiudadGrandeV2.csv tablaCiudadPequenaV2.csv /var/tmp
cp tablaItemGrande.csv tablaItemPequena.csv tablaItemGrandeV2.csv tablaItemPequenaV2.csv /var/tmp

sudo -u postgres psql -f shema.sql

#Creamos la base de datos
#createdb 12-10566
	
#psql 12-10566 < schema.sql

# Ejecuta el archivo .sql
#psql postgresql -f ciudades.sql	