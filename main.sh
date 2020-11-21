# ! /bin/bash
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
            echo ""
            ;;
        3) 
            echo ""
            ;;
        4) 
            echo ""
            ;;
        5) 
            echo ""
            ;;
        6)  
            echo "Salir del Programa"
            exit 0
            ;;
    esac
done    