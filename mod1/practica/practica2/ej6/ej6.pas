program ejer_4;
uses crt;

CONST

valorALTO = 9999;
N = 2;

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

procedure leer (var arc:detalle; var d:rec);
begin
	if(not eof(arc))then
		read(arc,d)
	else
		d.cod := valorAlto;
end;

function menorFecha(f1: Date; f2: Date): Boolean;
begin 
    menorFecha := (f1.anio < f2.anio) or 
                  ((f1.anio = f2.anio) and (f1.mes < f2.mes)) or 
                  ((f1.anio = f2.anio) and (f1.mes = f2.mes) and (f1.dia < f2.dia));
end;

procedure getRegistroMinimo(var dets:arDet; var recs: arRec; var min:rec);
var
    i, min_index:integer;
begin
    min_index:=0;
    min.cod := valorAlto;

    //comparo cada registro de recs para buscar el mínimo
    for i:=1 to N do
        if(recs[i].cod <> valorAlto) then //si el elemento i en recs tiene valor alto, es porque hemos llegado al final del detalle i
            if(recs[i].cod < min.cod) or ((recs[i].cod = min.cod) and menorFecha(recs[i].fecha, min.fecha))then begin//si es menor (menor cod o menor fecha con el mismo usuario)
                min := recs[i];
                min_index:=i;//estaba poniendo cero
            end;

    if(min_index <> 0) then
        leer(dets[min_index], recs[min_index]);
    //si veo que el registro mínimo ahora es el de índice 5, entonces tengo que avanzar en la lectura del detalle 5, actualizar el registro dentro de Recs y devolver en min lo que encontré al inicio

end;

function mismaFecha(f1: date; f2: date):boolean;
begin
    mismaFecha:= (f1.anio=f2.anio) and (f1.mes=f2.mes) and (f1.dia=f2.dia); //ponerle paréntesis poque sinó no funciona
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
        leer(dets[i], recs[i]); 
    end;

    getRegistroMinimo(dets, recs, min); //buscamos el mínimo de todos los detalles para avanzar en el correcto orden y no tener que hacer corrimiento de datos en el maestro

    while(min.cod <> valorAlto) do begin //para cada usuario
        aux.cod := min.cod; //aux tiene el codigo de usuario actual a buscar
        while (min.cod = aux.cod) do begin //mientras siga en el mismo usuario
            aux.tiempo :=0;  
            aux.fecha := min.fecha; //aux tiene la fecha actual
            while ( (min.cod = aux.cod) and mismaFecha(aux.fecha, min.fecha)) do begin //no olvidar de preguntar si es el mismo tipo, dado que avanzamos luego con la lectura
                aux.tiempo += min.tiempo; //sumo el tiempo de cada registro del mismo usuario y fecha
                getRegistroMinimo(dets, recs, min); //avanzo al siguiente registro en el orden que corresponde (eligiendo entre todos los detalles)
            end;
            write(arc_maestro, aux); //escribo cuando cambio de fecha. Aux ya tiene el codigo, fecha y tiempo correspondiente
        end;
    end;

    for i:=1 to n do
        close(dets[i]);
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