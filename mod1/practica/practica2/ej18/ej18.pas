program ejer5;
uses crt; 

CONST 
valorAlto = 9999;
n = 3;

type

fallecido = record
	matricula: string;
	fecha: string;
	hora:string;
	lugar:string;
end;

dead = record
	nro: integer;
	dni: string[8];
	nombre:string;
	datos: fallecido;
end;

alive = record
	nro: integer;
	nombre: string;
	direccion:	string;
	matricula:	string;
	nombreM:	string;
	dniM:	string;
	nombreP:	string;
	dniP:	string;
end;

cMaestro = record
	datos: alive;
	seMurio: boolean;
	enEfecto: fallecido;
end;

maestro = file of cMaestro; // lo tengo que crear

detalleVIVO = file of alive;
detalleMUERTO = file of dead;

arrayVIVO =array [1..n] of detalleVIVO;
arrayMUERTO = array [1..n] of detalleMUERTO;

arrayRV = array [1..n] of alive;
arrayRM = array [1..n] of dead;


procedure leerVIVO (var arc_detalle: detalleVIVO ; var dato:alive);
begin
	if not eof (arc_detalle) then
		read (arc_detalle,dato)
	else
		dato.nro:= valorAlto;
end;

procedure leerMUERTO (var arc_detalle: detalleMUERTO; var dato:dead);
begin
	if not eof (arc_detalle) then
		read (arc_detalle,dato)
	else
		dato.nro:= valorAlto;
end;

procedure imprimirMas (m:cMaestro);
begin
	with m do begin
		writeln ('|NRO: ',datos.nro,' |NOMBRE: ',datos.nombre,' |DIRECCION: ',datos.direccion,' |MATRICULA: ',datos.matricula);
		writeln ('NOMBRE MADRE: ',datos.nombreM,' |DNI MADRE: ',datos.dniM,' |NOMBRE PADRE: ', datos.nombreP,'| DNI PADRE: ', datos.dniP);
		writeln ('ESTA MUERTO?: ', seMurio,' |MATRICULA MEDICO: ', enEfecto.matricula);
		writeln ('FECHA: ', enEfecto.fecha,' |HORA DE FALLECIMIENTO: ',enEfecto.hora,' |LUGAR DE FALLECIMIENTO: ',enEfecto.lugar);
		writeln ('');
	end;
end;

procedure mostrarMaestro (var arc_maestro:maestro);
var
m:cMaestro;
begin
	reset (arc_maestro);
	while not eof (arc_maestro) do begin
		read (arc_maestro,m);
		imprimirMas(m);
	end;
	close (arc_maestro);
end;

procedure getVivoMinimo(var detaVIVO: arrayVIVO; var regVIVO: arrayRV; var minVIVO:alive);
var
    i, min_index:integer;

begin
    //comparo cada registro de regVIVO para buscar el mínimo
    min_index:=0;
    minVIVO.nro:=valorAlto;
    for i:=1 to N do
        if(regVIVO[i].nro <> valorAlto) then //si el elemento i en regVIVO tiene valor alto, es porque hemos llegado al final del detalle i
            if(regVIVO[i].nro < minVIVO.nro) then begin//si es de menor nro
                minVIVO := regVIVO[i];
                min_index:=i;
            end;

    if(min_index <> 0) then
        leerVIVO(detaVIVO[min_index], regVIVO[min_index]); 
    
    //si veo que el registro mínimo ahora es el de índice 5, entonces tengo que avanzar en la lectura del detalle 5, actualizar el registro dentro de Recs y devolver en min lo que encontré al inicio
end;

procedure getMuertoMinimo(var detaMUERTO: arrayMUERTO; var regMUERTO: arrayRM; var minMUERTO:dead);
var
    i, min_index:integer;

begin
    //comparo cada registro de regVIVO para buscar el mínimo
    min_index:=0;
    minMUERTO.nro:=valorAlto;
    for i:=1 to N do
        if(regMUERTO[i].nro <> valorAlto) then //si el elemento i en regVIVO tiene valor alto, es porque hemos llegado al final del detalle i
            if(regMUERTO[i].nro < minMUERTO.nro) then begin//si es de menor nro
                minMUERTO := regMUERTO[i];
                min_index:=i;
            end;

    if(min_index <> 0) then
        leerMUERTO(detaMUERTO[min_index], regMUERTO[min_index]); 
    
    //si veo que el registro mínimo ahora es el de índice 5, entonces tengo que avanzar en la lectura del detalle 5, actualizar el registro dentro de Recs y devolver en min lo que encontré al inicio
end;


procedure crearMaestro(var arc_maestro: maestro; var detaVIVO: arrayVIVO; var detaMUERTO: arrayMUERTO; var regVIVO: arrayRV; var regMUERTO: arrayRM);
var
    minVIVO: alive;
    minMUERTO: dead;
    i: integer;
    aux: cMaestro;

begin
    rewrite(arc_maestro);
    for i:=1 to n do begin //posicionamos cada detalle al inicio
        reset(detaVIVO[i]);
        reset(detaMUERTO[i]);
        leerVIVO(detaVIVO[i], regVIVO[i]); 
        leerMUERTO(detaMUERTO[i], regMUERTO[i]); 
    end;

    getVivoMinimo(detaVIVO, regVIVO, minVIVO);//todos nacieron, pero no todos murieron, por eso recorro principalmente en los vivos
    while(minVIVO.nro <> valorAlto) do begin
        //las personas no se repiten
        aux.datos:= minVIVO;
        aux.seMurio:=false;
        //veo si murio para completar más la info
        getMuertoMinimo(detaMUERTO, regMUERTO, minMUERTO);
        while(minMUERTO.nro < minVIVO.nro) do //si me paso puede ser porque no murió o por llegar al final con el valor alto
            getMuertoMinimo(detaMUERTO, regMUERTO, minMUERTO);
        
        if(minMUERTO.nro = minVIVO.nro) then begin
            aux.seMurio:=true;
            aux.enEfecto :=minMUERTO.datos;
        end;

        seek(arc_maestro, filepos(arc_maestro)- 1);
        write(arc_maestro, aux);
    end;

    close(arc_maestro);
    for i:=1 to n do begin //posicionamos cada detalle al inicio
        close(detaVIVO[i]);
        close(detaMUERTO[i]);
    end;
end;

var
arc_maestro: maestro;
detaVIVO: arrayVIVO;
detaMUERTO: arrayMUERTO;
regVIVO: arrayRV;
regMUERTO: arrayRM;
i: integer;
str_aux:string;

begin
	Assign (arc_maestro,'maestro');
    for i:=1 to n do begin
        Str(i, str_aux);
        assign(detaVIVO[i], 'detalleVIVO'+str_aux);
        assign(detaMUERTO[i], 'detalleMUERTO'+str_aux);
    end;
	crearMaestro (arc_maestro,detaVIVO,detaMUERTO,regVIVO,regMUERTO);
	mostrarMaestro (arc_maestro);
end.

