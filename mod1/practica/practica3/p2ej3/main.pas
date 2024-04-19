program main;
uses crt;

CONST

valorALTO = 9999;
N = 5;

type 

date =record
	dia:integer;
	mes:integer;
	anio:integer;
end;

rec = record
	cod:integer;
	fecha:date;
	tiempo:real;
end;


maestro = file of rec;
detalle = file of rec;

arDet = array [1..N] of detalle;
arRec = array [1..N] of rec;

procedure leerDetalle (var arc:detalle; var d:rec);
begin
	if(not eof(arc))then
		read(arc,d)
	else
		d.cod := valorAlto;
end;

procedure leerMaestro (var arc:maestro; var d:rec);
begin
	if(not eof(arc))then
		read(arc,d)
	else
		d.cod := valorAlto;
end;

function mismaFecha(f1: date; f2: date):boolean;
begin
    mismaFecha:= (f1.anio=f2.anio) and (f1.mes=f2.mes) and (f1.dia=f2.dia); //ponerle paréntesis poque sinó no funciona
end;

procedure actualizarMaestro (var arc_maestro:maestro; var arc_detalle:detalle);
var
    encontre:boolean;
    dato, aux:rec;

begin
    leerDetalle(arc_detalle, dato);
    while(dato.cod <> valorAlto) do begin
        encontre:=false;
        seek(arc_maestro, 0);
        leerMaestro(arc_maestro, aux);
        while(aux.cod <> valorAlto) and not(encontre) do begin
            if(aux.cod = dato.cod) and mismaFecha(aux.fecha, dato.fecha) then begin
                aux.tiempo:= aux.tiempo + dato.tiempo;
                seek(arc_maestro, filepos(arc_maestro)-1);
                write(arc_maestro, aux); //guardo cambios
                encontre:=true;
            end
            else begin
                leerMaestro(arc_maestro, aux);
            end;
        end;
        if not(encontre) then begin //si no encontre un reg para actualizar, entonces lo creo
            seek(arc_maestro, fileSize(arc_maestro));
            write(arc_maestro, dato);
        end;
        leerDetalle(arc_detalle, dato);
    end;
end;

procedure crearMaestro (var arc_maestro:maestro; var dets: arDet);
var
    i:integer;
    recs: arRec; //tenemos el mínimo registro no leído de cada detalle, para poder avanzar de a todos los detalles a la vez
    aux, min:rec;

begin
    rewrite(arc_maestro);
    for i:=1 to n do begin //posicionamos cada detalle al inicio
        reset(dets[i]);
        actualizarMaestro(arc_maestro, dets[i]);
        close(dets[i]);
    end;
    close(arc_maestro);
end;

procedure imprimirMas (m:rec);
begin
	with m do begin
		writeln ('CODIGO: ',cod);
		writeln ('FECHA: ',fecha.dia,'/', fecha.mes, '/', fecha.anio);
		writeln ('TIEMPO TOTAL DE SESIONES ABIERTAS ',tiempo:0:2);
		writeln ('');
	end;
end;

procedure mostrarMaestro (var arc_maestro:maestro);
var
m:rec;
begin
	reset (arc_maestro);
	while not eof (arc_maestro) do begin
		read (arc_maestro,m);
		imprimirMas(m);
	end;
	close (arc_maestro);
end;

var
    arcM:maestro;
    dets:arDet;
    i:integer;
    numero:string;

begin
	Assign (arcM,'maestro');
	for i:= 1 to N do begin
		Str (i,numero);
		Assign (dets[i],'detalle'+numero);
	end;
	crearMaestro (arcM,dets);
    writeln('Maestro creado: ');
	mostrarMaestro(arcM);
end.