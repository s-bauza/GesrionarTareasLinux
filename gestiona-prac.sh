#!/bin/bash


echo  -e "\nASO 22/23 - Practica 6\nSantiago Bauzá Hirschler\n\nGestion de practicas\n--------------------"

#OPCIONES

a="Programar recogida de prácticas"
b="Empaquetado de prácticas de una asignatura"
c="Ver tamaño y fecha del fichero de una asignatura"
d="Finalizar programa"

rutaLog="/media/kali/ESD-USB/ASO/P6/informe-prac.log"
rutaRecogePracticas="/media/kali/ESD-USB/ASO/P6/recoge-prac.sh"

PS3="Opción: "


recogida_practica(){
echo -e "\nMenú 1 – Programar recogida de prácticas\n"
read -p "Asignatura cuyas prácticas desea recoger: " asig
read -p "Ruta con las cuentas de los alumnos: " rutaOrig
read -p "Ruta para almacenar prácticas: " rutaDest
if [ ! -d $rutaOrig ] ; then
echo -e "Log of echo -e\n$(date)\n\nNo existe la ruta  origen.\nVolvinedo al menú principal\n\n$(date)\n----------------" >> $rutaLog;
echo -e "No existe la ruta  origen.\nVolvinedo al menú principal"
menu_principal
fi
if [ ! -d $rutaDest ] ; then
echo -e "Log of echo -e\n$(date)\n\nNo existe la ruta  destino.\nVolvinedo al menú principal\n\n$(date)\n----------------" >> $rutaLog;
echo -e "No existe la ruta  destino.\nVolvinedo al menú principal"
menu_principal
fi
echo -e "Se va a programar la recogida de las prácticas de $asig para mañana a las 8:00. Origen: $rutaOrig Destino: $rutaDest"
while true; do
    read -p "Desea Continuar S/N?" op
    case $op in
      [Ss]* ) echo -e "Log of echo \n$(date)\n\nLa recogida de practicas ha sido programada. ! \n\n$(date)\n----------------" >> $rutaLog;
      	      echo "La recogida de practicas ha sido programada. !"
              crontab -l > crontab_new
              echo "0 8 * * * bash $rutaRecogePracticas $rutaOrig $rutaDest $rutaLog " >> crontab_new
              cat crontab_new | sort | uniq > crontab_new_aux
              crontab crontab_new_aux
              rm crontab_new
              rm crontab_new_aux
              sleep 10;break;;
      [Nn]* ) echo -e "Log of echo \n$(date)\n\nLa recogida no ha sido programada. ! \n\n$(date)\n----------------" >> $rutaLog;
      	      echo "La recogida no ha sido programada. !" ; break;;
          * ) echo "Seleccione Si o No.";;
    esac
done
}


empaquetar_practicas(){
echo -e "\nMenú 2 – Empaquetar prácticas de la asignatura\n"
read -p "Asignatura cuyas prácticas se desea empaquetar: " asig
read -p "Ruta absoluta del directorio de prácticas:" rutaAbsolutaDirectorio
if [ ! -d $rutaAbsolutaDirectorio ] ; then
echo -e "Log of echo -e\n$(date)\n\nEl directorio a salvar no existe.\nVolvinedo al menú principal\n\n$(date)\n----------------" >> $rutaLog;
echo -e "El directorio a salvar no existe.\nVolvinedo al menú principal"
menu_principal
fi
if [  -f $rutaAbsolutaDirectorio/$asig-$(date +%y%m%d).tgz  ]; then
echo -e "Log of echo -e\n$(date)\n\nEl archivo .tgz ya existe\n\n$(date)\n----------------" >> $rutaLog;
echo -e "El archivo .tgz ya existe"
menu_principal
fi
echo -e "Se van a empaquetar las prácticas de la asignatura $asig presentes en el directorio $rutaAbsolutaDirectorio."
while true; do
    read -p "Desea Continuar S/N?" op
    case $op in
      [Ss]* ) echo -e "Log of echo \n$(date)\n\nLas prácticas han sido empaquetadas. ! \n\n$(date)\n----------------" >> $rutaLog;
              echo "Las prácticas han sido empaquetadas. !"
              echo -e "Log of cd $rutaAbsolutaDirectorio && tar czf $asig-$(date +%y%m%d).tgz\n$(date)\n\n$($(cd $rutaAbsolutaDirectorio && tar cpzf $asig-$(date +%y%m%d).tgz *) >> $rutaLog && echo "OK" || echo "FAILED")\n\n$(date)\n\n----------------" >> $rutaLog;
              sleep 10;break;;
      [Nn]* ) echo -e "Log of echo \n$(date)\n\La prácticas no ha sido empaquetadas. ! \n\n$(date)\n----------------" >> $rutaLog;
              echo "La prácticas no ha sido empaquetadas. !" ; break;;
          * ) echo "Seleccione Si o No.";;
    esac
done

}

obtener_nBytesFichero(){
echo -e "\nMenú 3 – Obtener tamaño y fecha del fichero\n"
read -p "Asignatura sobre la que queremos información: " asig
read -p "Ruta absoluta del archivo de prácticas (incluido al final):" rutaAbsolutaArchivo
if [ ! -f $rutaAbsolutaArchivo ] ; then
echo -e "Log of echo -e\n$(date)\n\El fichero $rutaAbsolutaArchivo no existe.\nVolvinedo al menú principal\n\n$(date)\n----------------" >> $rutaLog;
echo -e "El fichero $rutaAbsolutaArchivo no existe.\nVolvinedo al menú principal"
menu_principal
fi
echo -e "Log of echo \n$(date)\n\nEl fichero generado es $(basename $rutaAbsolutaArchivo) y ocupa $(cat $rutaAbsolutaArchivo | wc -c ) bytes.\n\n$(date)\n----------------" >> $rutaLog;
echo "El fichero generado es $(basename $rutaAbsolutaArchivo) y ocupa $(cat $rutaAbsolutaArchivo | wc -c ) bytes."
sleep 10;
}


menu_principal () {
echo -e "	\nMenú"
select menu in "$a" "$b" "$c" "$d";
do
	case $menu in
		$a)clear
			recogida_practica
			sleep 3
			clear
			menu_principal
			;;
		$b)clear
			empaquetar_practicas
			sleep 3
			clear
			menu_principal
			;;
		$c)clear
			obtener_nBytesFichero
			sleep 3
			clear
			menu_principal
			;;
		$d)clear
			exit
			;;
		*)
			echo "(*) $REPLY no es una opción valida"
			;;
	esac
done
}
menu_principal
