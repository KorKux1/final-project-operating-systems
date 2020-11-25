#! /bin/bash
option=0

##
# Print the options menu
## 
print_menu() {
    echo "----------------------------------------------------------------------------------------------------------------------"
    echo "| 1. Consultar la memoria consumida de los cinco procesos que más memoria esté consumiendo en ese momento"
    echo "| 2. Consultar los filesystems que estén llenos en más de un 60% con su tamaño, espacio libre y punto de montura"
    echo "| 3. Consultar los 5 archivos más grandes de un tipo especifico dada una carpeta"
    echo "| 4. Guardar registros uso de memoria"
    echo "| 5. Consultar registro donde hubo menor cantidad de memoria libre y mayor cantidad de swap libre."
    echo "| 6. Salir"
    echo "----------------------------------------------------------------------------------------------------------------------"
}

get_process_consume_more_memory() {
    clear
    ps aux --sort=-%mem | head -n 5
}

get_filesystems_more_60_memory() {
    clear
    df -P | awk '0+$5 >= 60 {printf("%s %8s %8s %8s \n", $1, $4, $5, $6)}'
}

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

get_min_memory_free_and_max_used_swap() {
    clear
    echo "Registro con la menor cantidad de memoria libre:"
    awk -F ',' '{if(max<$3){max=$3; salary=$3}}END{print}' $HOME/registro.txt
    echo "Registro con el mayor uso de memoria swap:"
    awk -F ',' 'NR == 1 || $2 < min {min = $2}END{print}' $HOME/registro.txt
}

while :
do
    # Print the Menu
    print_menu

    # Read option
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