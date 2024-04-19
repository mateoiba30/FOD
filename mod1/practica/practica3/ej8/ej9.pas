{8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse.
Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de
reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si
la distribución existe en el archivo o falso en caso contrario.
AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la
agrega al archivo reutilizando espacio disponible en caso de que exista. (El control de
unicidad lo debe realizar utilizando el módulo anterior). En caso de que la distribución que
se quiere agregar ya exista se debe informar “ya existe la distribución”.
BajaDistribución: módulo que da de baja lógicamente una distribución  cuyo nombre se
lee por teclado. Para marcar una distribución como borrada se debe utilizar el campo
cantidad de desarrolladores para mantener actualizada la lista invertida. Para verificar
que la distribución a borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no
existir se debe informar “Distribución no existente”.}

program ejer8;

CONST
    valorAlto = 'ZZZ';
    FIN = '@@'; 

type

linux = record
	nom:string[50];
	anio:string[10];
	num:string[5];
	cant:integer;
	des:string[50];
end;

archivo = file of linux;

procedure leerArc (var arc_log:archivo; var dato:linux);
begin
	if not eof (arc_log) then
		read (arc_log,dato)
	else
		dato.nom := valorAlto;
end;

procedure leer (var n:linux);
begin
	with n do begin
		write ('INGRESE NOMBRE ("',FIN,'" para finalizar): '); readln (nom);
		if (nom <> '@@') then begin
			write ('INGRESE ANIO: ');	readln (anio);
			write ('INGRESE NUMERO DE VERSION: ');	readln (num);
			write ('INGRESE CANTIDAD DE DESARROLLADORES: '); readln (cant);
			write ('INGRESE DESCRIPCION: '); readln (des);
		end;
	end;
	writeln ('');
end;

procedure imprimir (n:linux);
begin
	with n do begin
        writeln ('|NOMBRE: ',nom,'|ANIO: ',anio,'|NUMERO VERSION: ',num,'|CANTIDAD DE DESARROLLADORES: ',cant,' |DESCRIPCION: ',des);
        writeln ('');
	end;
end;

procedure crear (var arc_log:archivo);
var
n:linux;
begin
	rewrite (arc_log);
	n.cant := 0;
	write (arc_log,n);//escribo cabecera
	leer (n);
	while (n.nom <> FIN) do begin
		write (arc_log,n);
		leer(n);
	end;
	close (arc_log);
end;

procedure mostrarPantalla (var arc_log:archivo);
var
	n:linux;
begin
	reset(arc_log);
	//seek (arc_log,1);//salteo cabecera
	leerArc(arc_log,n);
	while (n.nom <> valorAlto) do begin
		imprimir (n);
		leerArc(arc_log,n);
	end;
	close(arc_log);
end;

function ExisteDistribucion(nom:string; var arc_log:archivo):integer;
var 
    l:linux;
    encontre:boolean;
    posIni:integer;

begin
    reset(arc_log);

    encontre:=false;
    leerArc(arc_log, l);//paso la cabecera
    leerArc(arc_log, l);
    while(l.nom<>valorAlto) and not(encontre) do begin
        if(l.nom = nom) and (l.cant > 0) then //la cantidad debe ser mayor a cero porque puede ser un borrado logico
            encontre:=true
        else
            leerArc(arc_log, l);
    end;
    posIni:=-1;
    if(encontre) then
        posIni:=filepos(arc_log)-1;
    close(arc_log);
    ExisteDistribucion:=posIni;
end;

procedure AltaDistribucion (var arc_log:archivo);
var
    l, cabecera, libre:linux;

begin
    writeln('Ingrese el nombre de la distribucion a agregar: ');
    readln(l.nom);
    while(ExisteDistribucion(l.nom, arc_log)<>-1) do begin
        writeln('Ya existe la distribucion, ingrese otro nombre: ');
        readln(l.nom);
    end;
    writeln('Ingrese el anio de lanzamiento: ');
    readln(l.anio);
    writeln('Ingrese el numero de version del kernel: ');
    readln(l.num);
    writeln('Ingrese la cantidad de desarrolladores: ');
    readln(l.cant);
    writeln('Ingrese la descripcion: ');
    readln(l.des);

    reset(arc_log);
    leerArc(arc_log, cabecera);
    if(cabecera.cant = 0) then begin //si no hay espacio logico
        seek(arc_log, fileSize(arc_log));
        write(arc_log, l);
    end
    else begin
        seek(arc_log, -1*cabecera.cant); //voy al 1er espacio libre
        read(arc_log, libre); //seguro no llego a EOF
        seek(arc_log, filePos(arc_log)-1); //retrocedo
        write(arc_log, l);//sobreescribo datos
        seek(arc_log, 0);
        write(arc_log, libre);//actualizo la cabecera
    end;

    writeln('Distribucion agregada correctamente');
    close(arc_log);
end;

procedure BajaDistribucion (var arc_log:archivo);
var
    nom:string;
    cabecera, l:linux;
    posIni:integer;

begin   
    writeln('Ingrese el nombre de la distribucion a dar de baja: ');
    readln(nom);
    posIni:=ExisteDistribucion(nom, arc_log);

    if(posIni<>-1) then begin
        
        reset(arc_log);
        leerArc(arc_log, cabecera);
        seek(arc_log, posIni);
        read(arc_log, l);//seguro leo sin llegar a EOF porque es la pos de quien busco

        l.cant:=cabecera.cant;
        seek(arc_log, posIni);
        cabecera.cant:=-1*posIni;

        write(arc_log, l); //guardo cambios
        seek(arc_log, 0);
        write(arc_log, cabecera);
        writeln('Distribucion dada de baja correctamente');
        close(arc_log);

    end
    else begin
        writeln('Distribucion no existente');
    end;
end;

var
arc_log:archivo;
begin
	Assign (arc_log,'archivo.dot');
	writeln ('CREAR');
	crear(arc_log);
	mostrarPantalla(arc_log);
    //writeln(ExisteDistribucion('Ubuntu',arc_log));
    writeln('BAJA');
	writeln ('');
	BajaDistribucion(arc_log);
	writeln ('');
    mostrarPantalla(arc_log);
    writeln('BAJA');
	writeln ('');
	BajaDistribucion(arc_log);
	writeln ('');
    mostrarPantalla(arc_log);
	writeln ('ALTA');
	writeln ('');
	AltaDistribucion(arc_log);
	writeln ('');
	mostrarPantalla(arc_log);
end.