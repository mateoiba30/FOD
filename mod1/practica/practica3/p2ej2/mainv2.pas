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

maestro = file of cMaestro;
contador = file of integer;

procedure leer (var arc_maestro:maestro; var dato:cMaestro);
begin
	if not eof (arc_maestro) then
		read (arc_maestro,dato)
	else
		dato.codP:= valorAlto;
end;

procedure leerContador (var arc_contador:contador; var cont:integer);
begin
	if not eof (arc_contador) then
		read (arc_contador,cont)
	else
		cont:= valorAlto;
end;

procedure listado(var arc_maestro: maestro; var arc_contador: contador);
var
    vot_tot, vot_loc, aux, pos, codLActual: integer;
    dato: cMaestro;
    yaProcesado:boolean;

begin //creo que en la version anterior interpreté mal la consigna. Ahora recorro el maestro que repite la localidad y guardo en un archivo las localidades que ya procesé del maestro
    vot_tot:= 0;
    vot_loc:=0;
    reset(arc_maestro);
    rewrite(arc_contador);

    writeln('Localidad   Votos');
    leer(arc_maestro, dato);
    while (dato.codP <> valorAlto) do begin //para el archivo
        //actualizar el archivo auxiliar que acumula los votos por localidad
        vot_tot:=vot_tot + dato.cantV;
        
        yaProcesado:=false;
        seek(arc_contador, 0);//siempre buscar desde el inicio porque no hay orden en el maestro
        leerContador(arc_contador, aux);
        while(aux <> valorAlto) and not(yaProcesado) do begin
            if(aux = dato.codL) then begin
                yaProcesado:= true;
                //writeln('yaProcesado'); //para debuguear
            end
            else begin
                leerContador(arc_contador, aux);
            end;
        end;
        if not(yaProcesado) then begin
            codLActual:=dato.codL;
            seek(arc_contador, fileSize(arc_contador));
            write(arc_contador, codLActual);//guardo la localidad para no volver a procesarla
            pos := filePos(arc_maestro);//guardo la posición para no analizar desde el inicio al maestro la proxima vez
            vot_loc:=dato.cantV;
           
            leer(arc_maestro, dato);
            while(dato.codP <> valorAlto) do begin
                if(dato.codL = codLActual) then begin
                    vot_loc+=dato.cantV;
                    writeln('Vot_loc: ', vot_loc, ' dato catV: ', dato.cantV); //para debuguear
                    //break;
                end;
                leer(arc_maestro, dato); //no quiero leer algo incorrecto porque desp debo imprimir la localidad
            end;
            writeln(codLActual, '   ', vot_loc);
            seek(arc_maestro, pos);
            vot_loc:=0;
        end;

        leer(arc_maestro, dato);
    end;

    close(arc_contador);
    close(arc_maestro);
    writeln('Total general de votos: ', vot_tot);
end;

procedure imprimirCl(c:cMaestro);
begin
	with c do begin
		writeln ('CODIGO PROVINCIA: ',codP);
		writeln ('CODIGO LOCALIDAD: ',codL);
		writeln ('NUMERO MESA: ',nro);
		writeln ('CANTIDAD VOTOS: ',cantV);
		writeln ('');
	end;
end;

procedure mostrarMaestro (var arc_maestro:maestro);
var
c:cMaestro;
begin
	reset (arc_maestro);
	while not eof (arc_maestro) do begin
		read (arc_maestro,c);
		imprimirCl(c);
	end;
	close (arc_maestro);
end;

var
arc_maestro:maestro;
arc_contador:contador;

begin
	Assign (arc_maestro,'maestro');
    assign(arc_contador, 'contador');
    //mostrarMaestro (arc_maestro);
	listado (arc_maestro, arc_contador);
end.