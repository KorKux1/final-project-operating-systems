#! /bin/bash
<< 'MULTI-COMMENT'
Integrantes: David Obando, Cristian Castillo, John Camilo Sepulveda, Sebastián Correa

El proyecto consiste en un script bash que facilite las labores del administrador de un data center, como consultar procesos que consumen más memoria, ver los filesystems más llenos,
conocer los archivos más grandes...Entre otros servicios.

Ejecución: 
bash main.sh
MULTI-COMMENT

##
# Imprimir las opciones del menu
## 
print_menu() {
    echo "----------------------------------------------------------------------------------------------------------------------"
    echo "| 1. Consultar la memoria consumida de los cinco procesos que más memoria esté consumiendo en ese momento"
    echo "| 2. Consultar los filesystems que estén llenos en más de un 60% con su tamaño, espacio libre y punto de montura"
    echo "| 3. Consultar los 5 archivos más grandes de un tipo especifico dada una carpeta"
    echo "| 4. Guardar registros uso de memoria"
    echo "| 5. Consultar registro donde hubo menor cantidad de memoria libre y mayor cantidad de swap usada."
    echo "| 6. Salir"
    echo "----------------------------------------------------------------------------------------------------------------------"
}

#Sinopsis:
#Punto 1. Función que despliega una tabla con los cinco procesos que más memoria esté consumiendo en ese momento, mostrando solamente
#el usuario, el PID y el % de memoria consumida.
 
#Comandos:
#ps aux: Comando usado para encontrar todos los procesos del usuario
#--sort=-%mem: Comando usado para ordenar los procesos según el porcentaje de memoria consumiento (Mayor a menor)
#awk '{print $1, $2, $4}': Comando usado para filtar las columnas user, PID, % MEM.
#head -n 6: Comando usado para obtener los primeros 5 procesos entregados
#column -t: Comando usado para mostrar la salida en forma de tabla
get_process_consume_more_memory() {
    clear
    ps aux --sort=-%mem | awk '{print $1, $2, $4}' | head -n 6 | column -t
}

#Sinopsis:
#Punto 2. Función que despliega los filesystems que estén llenos en más de un 60% con su tamaño, espacio libre y punto de montura.
 
#Comandos:
#df -h: Comando usado para encontrar todos los filesystems
#awk: Comando usado para ordenar desplegar solamente el nombre, tamaño, espacio libre y punto de montura del filesystem
#column -t: Comando usado para mostrar la salida en forma de tabla
get_filesystems_more_60_memory() {
    clear
    df -h | awk '0+$5 >= 10 {printf("%s %8s %8s %8s \n", $1, $2, $4, $6)}' | column -t
}

#Sinopsis:
#Punto 3. Función que despliega los 5 archivos más grandes de un tipo especifico(.txt,.sh,.docx,.xlsx) dada una carpeta o directorio
 
#Comandos:
#find "$(pwd)": Comando usado para encontrar los archivos pertenecientes al directorio actual
#-name "*$type_var": Parametro usado para obtener los archivos que sean del tipo especificado por el usuario
#sort -r: Comando usado para ordenar de mayor a menor los archivos de acuerdo al tamaño
#head -n 5: Comando usado para sacar los 5 primeros archivos después de ser ordenados

#Variables:
#directory: Directorio o carpeta dada por el usuario
#type_var: Tipo de archivo dado por el usuario (i.e, .txt,.sh,.docx,.xlsx)

#Funcionamiento:
#Si el directorio ingresado por el usuario no existe se imprimirá un mensaje informandole al usuario,
#En caso contrario, se procederá a pedir el tipo de archivo buscado y de esa forma desplegar los archivos del directorio que cumplan
get_larger_files(){
    clear
    read -p "Digite el directorio: " directory
    if [ -d $directory ]
        then
            cd $directory
            read -p "Digite el tipo de archivo: (ej- .txt .sh .docx) " type_var
            find "$(pwd)" -name "*$type_var"| sort -r | head -n 5

        else
            echo "El directorio $directory no existe"
    fi
}

#Sinopsis:
#Punto 4. Función que guarda registros en un archivo $HOME/registro.txt con la cantidad de memoria libre, cantidad del espacio de swap en uso y fecha actual
 
#Comandos:
#date: Comando usado para obtener la fecha actual
#free: Comando usado para obtener la cantidad de memoria libre y del espacio de swap en uso 
#awk: Comando usado para obtener la columna deseada
#cat: Comando usado para imprimir el contenido del archivo $HOME/registro.txt

#Variables:
#now: Fecha actual
#free_ram: Cantidad de memoria libre
#used_swap: Cantidad del espacio de swap en uso

#Funcionamiento:
#Si el archivo $HOME/registro.txt existe entonces agrega las variables now, free_ram y used_swap al archivo de text,
#En caso contrario, primero crea el archivo agregado la primera linea con el texto date,free_ram,used_swap (titulo de las columnas)
get_memory_usage(){
    clear
    now=`date`
    free_ram=`free | awk 'NR ==2  {print $4}'`
    used_swap=`free | awk 'NR ==3  {print $3}'`
    if [ -f "$HOME/registro.txt" ]; then
        echo "$now,$free_ram,$used_swap" >> $HOME/registro.txt
    else
        echo "date,free_ram,used_swap" >> $HOME/registro.txt
        echo "$now,$free_ram,$used_swap" >> $HOME/registro.txt
    fi
    cat $HOME/registro.txt
}

#Sinopsis:
#Punto 5. Función que consulta y muestra el registro, creado en el punto anterior, donde hubo menor cantidad de memoria libre y mayor cantidad de swap usada

#Comandos:
#awk -F: Comando usado para mostrar el registro con la menor cantidad de memoria libre
#awk -F: Comando usado para mostrar el registro con la mayor cantidad de swap usada

#Funcionamiento:
#En el switch case 5 se llama a esta función. Si el archivo no existe se llama al punto 4, en caso contrario se despliega
#el registro con la menor cantidad de memoria libre y el registro con la mayor cantidad de swap usada 
get_min_memory_free_and_max_used_swap() {
    clear
    echo "Registro con la menor cantidad de memoria libre:"
    awk -F ',' '{if(max<$3){max=$3; salary=$3}}END{print}' $HOME/registro.txt
    echo "Registro con el mayor uso de memoria swap:"
    awk -F ',' 'NR == 1 || $2 < min {min = $2}END{print}' $HOME/registro.txt
}

#Permite desplegar el menu y consultar los servicios. Para salir del programa se debe ingresar el número 6
while :
do
    # Imprimir menu
    print_menu

    # Leer opción
    read -p "Ingrese una opción [1-6]:" option

    case $option in
        1) 
            get_process_consume_more_memory
            ;;
        2) 
            get_filesystems_more_60_memory
            ;;
        3) 
            get_larger_files
            ;;
        4) 
            get_memory_usage
            ;;
        5)  
            if [ -f "$HOME/registro.txt" ]; then
                get_min_memory_free_and_max_used_swap
            else
               get_memory_usage
               get_min_memory_free_and_max_used_swap
            fi
            ;;
        6)  
            echo "Salir del Programa"
            exit 0
            ;;
    esac
done