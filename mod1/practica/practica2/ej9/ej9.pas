program ejer9;

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

procedure leer (var arc_maestro:maestro; var dato:cMaestro);
begin
	if not eof (arc_maestro) then
		read (arc_maestro,dato)
	else
		dato.codP:= valorAlto;
end;

procedure listado(var arc_maestro: maestro);
var
    vot_tot, vot_prov, vot_loc: integer;
    dato, aux: cMaestro;

begin
    vot_tot:= 0;
    reset(arc_maestro);

    leer(arc_maestro, dato);
    while (dato.codP <> valorAlto) do begin //para el archivo
        vot_prov:= 0;   
        aux.codP:= dato.codP;
        writeln('Codigo de Provincia: ', aux.codP);
        while(aux.codP = dato.codP) do begin //por provincia
            vot_loc:=0;
            aux.codL:= dato.codL;
            while (aux.codP = dato.codP)  and (aux.codL = dato.codL) do begin //por localidad
                vot_loc:= vot_loc + dato.cantV;
                leer(arc_maestro, dato); //no olvidar avanzar en el último bucle
            end;
            vot_prov+=vot_loc;
            writeln('Codigo de Localidad   Total de votos');
            writeln(aux.codL:19, vot_loc:17);
        end;
        vot_tot+=vot_prov;
        writeln('Total de votos de la provincia: ', vot_prov);
        writeln('');
    end;
    writeln('Total general de votos: ', vot_tot);

    close(arc_maestro);
end;

var
arc_maestro:maestro;

begin
	Assign (arc_maestro,'maestro');
	listado (arc_maestro);
end.