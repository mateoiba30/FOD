program ej15;
uses crt;

CONST 
valorAlto = 9999;
n = 3;

type

cMaestro = record
	codP:integer;
	nomP:string;
	codL:integer;
	nomL:string;
	vSinL:integer;
	vSinG:integer;
	vDeC:integer;
	vSinA:integer;
	vSinS:integer;
end;

cDetalle = record
	codP:integer;
	codL:integer;
	vConL:integer;
	vConG:integer;
	vConst:integer;
	vConA:integer;
	vEntregaS:integer;
end;

maestro = file of cMaestro;
detalle = file of cDetalle;

arDet = array [1..n] of detalle;
regDet = array [1..n] of cDetalle;

procedure leer (var arc_detalle:detalle; var dato:cDetalle);
begin
	if not eof (arc_detalle) then
		read (arc_detalle,dato)
	else
		dato.codP := valorAlto;
end;

procedure leerMaestro(var arc_maestro: maestro; var dato:cMaestro);
begin
    if not eof(arc_maestro) then
        read(arc_maestro, dato)
    else
        dato.codP := valorAlto;
end;

procedure getRegistroMinimo(var dets:arDet; var recs:regDet; var min:cDetalle);
var
    i, min_index:integer;

begin
    //comparo cada registro de recs para buscar el mínimo
    for i:=1 to n do
        if(recs[i].codP <> valorAlto) then //si el elemento i en recs tiene valor alto, es porque hemos llegado al final del detalle i
            if(recs[i].codP < min.codP) or ((recs[i].codP = min.codP) and (recs[i].codL < min.codL))then begin//si es de menor cod
                min := recs[i];
                min_index:=i;
            end;

    if(min_index <> 0) then
        leer(dets[min_index], recs[min_index]);
    //si veo que el registro mínimo ahora es el de índice 5, entonces tengo que avanzar en la lectura del detalle 5, actualizar el registro dentro de Recs y devolver en min lo que encontré al inicio
end;

procedure actualizar(var arc_maestro: maestro; var min:cDetalle);
var
    dato:cMaestro;
begin
    leerMaestro(arc_maestro, dato);
    while(dato.codP <> valorAlto) and (dato.codP <> min.codP) do //no se si es necesario asegurarme de encontrarlo
        leerMaestro(arc_maestro, dato);
    
    if dato.codP = min.codP then begin
        dato.vSinL-=min.vConL;
        dato.vSinG-=min.vConG;
        dato.vDeC-=min.vConst;
        dato.vSinA-=min.vConA;
        dato.vSinS-=min.vEntregaS;

        seek(arc_maestro, filepos(arc_maestro)-1);
        write(arc_maestro, dato);
    end;
end;

procedure actualizarMaestro(var arc_maestro: maestro; var dets:arDet);
var
    i:integer;
    recs: regDet;
    min:cDetalle;

begin
    reset(arc_maestro);
    for i:=1 to n do begin //posicionamos cada detalle al inicio
        reset(dets[i]);
        leer(dets[i], recs[i]); 
    end;

    getRegistroMinimo(dets, recs, min); //buscamos el mínimo de todos los detalles para avanzar en el correcto orden y no tener que hacer corrimiento de datos en el maestro
    while(min.codP <> valorAlto) do begin //para todos los detalles
        //La misma combinación de provincia y localidad aparecen a lo sumo una única vez
        actualizar(arc_maestro, min);
        getRegistroMinimo(dets, recs, min);
    end;

    for i:=1 to n do
        close(dets[i]);
    close(arc_maestro);
end;

var
dets:arDet;
arc_maestro:maestro;
i:integer;
m:cMaestro;
str_aux:string;

begin
	Assign (arc_maestro,'maestro');
    for i:=1 to n do begin  
        Str(i,str_aux);
        assign(dets[i], 'detalle'+str_aux);
    end;

	actualizarMaestro (arc_maestro, dets);//no puedo informar acá porque solo paso por las localidades actualizadas
    //informarSinChapa(arc_maestro);
end.