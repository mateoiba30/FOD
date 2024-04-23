program main;

CONST
valorAlto = 9999;

type
cMaestro = record
	codP:integer;
	codL:integer;
	nro:integer;
	cantV:integer;
end;

reg_contador = record
    codL, cantV:integer;
end;

maestro = file of cMaestro;
contador = file of reg_contador;

procedure leer (var arc_maestro:maestro; var dato:cMaestro);
begin
	if not eof (arc_maestro) then
		read (arc_maestro,dato)
	else
		dato.codP:= valorAlto;
end;

procedure leerContador (var arc_contador:contador; var cont:reg_contador);
begin
	if not eof (arc_contador) then
		read (arc_contador,cont)
	else
		cont.codL:= valorAlto;
end;


procedure mostrarContador (var arc_contador: contador);
var
    cont:reg_contador;

begin
    reset(arc_contador);
    writeln('Codigo de Localidad   Cantidad de Votos');
    leerContador(arc_contador, cont);
    while(cont.codL <> valorAlto) do begin
        writeln(cont.codL, '   ', cont.cantV);
        leerContador(arc_contador, cont);
    end;

    close(arc_contador);
end;

procedure listado(var arc_maestro: maestro; var arc_contador: contador);
var
    vot_tot: integer;
    dato: cMaestro;
    aux: reg_contador;
    encontre:boolean;

begin
    vot_tot:= 0;
    reset(arc_maestro);
    rewrite(arc_contador);

    leer(arc_maestro, dato);
    while (dato.codP <> valorAlto) do begin //para el archivo
        //actualizar el archivo auxiliar que acumula los votos por localidad
        vot_tot+=dato.cantV;

        encontre:=false;
        seek(arc_contador, 0);//siempre buscar desde el inicio porque no hay orden en el maestro
        leerContador(arc_contador, aux);
        while(aux.codL <> valorAlto) and not(encontre) do begin
            if(aux.codL = dato.codL) then begin
                //writeln('Encontre');
                aux.cantV+=dato.cantV;
                seek(arc_contador, filePos(arc_contador)-1);
                write(arc_contador, aux);//guardo cambios en el archivo
                encontre:= true;
            end
            else begin
                leerContador(arc_contador, aux);
            end;
        end;
        if not(encontre) then begin //si no encontre un reg para actualizar, entonces lo creo
            //writeln('No encontre');
            seek(arc_contador, fileSize(arc_contador));
            aux.codL:= dato.codL;
            aux.cantV:= dato.cantV;
            write(arc_contador, aux);
        end;

        leer(arc_maestro, dato);
    end;

    close(arc_contador);
    close(arc_maestro);

    mostrarContador(arc_contador);
    writeln('Total general de votos: ', vot_tot);
end;

var
arc_maestro:maestro;
arc_contador:contador;

begin
	Assign (arc_maestro,'maestro');
    assign(arc_contador, 'contador');
	listado (arc_maestro, arc_contador);
end.