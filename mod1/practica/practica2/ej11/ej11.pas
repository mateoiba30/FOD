program ejer12;

CONST
valorAlto = 2023;

type
a = 2000..2023;
me = 1..12;
d = 1..31;

cMaestro = record
	anio:a;
	mes:me;
	dia:d;
	idUs:integer;
	tiempoAc: real;
end;

maestro = file of cMaestro;

procedure leer (var arc_maestro:maestro; var dato:cMaestro);
begin
	if not eof (arc_maestro) then
		read (arc_maestro,dato)
	else
		dato.anio := valorAlto;
end;

procedure mostrarReporte (var arc_maestro:maestro; anio:a);
var
    dato: cMaestro;
    accesos_anuales, accesos_mensuales, accesos_diarios, accesos_usuario: real;
    aux: cMaestro;

begin
    reset(arc_maestro);
    leer(arc_maestro, dato);
    while ((dato.anio <> valorAlto) and (dato.anio <> anio)) do
        leer(arc_maestro, dato);
    
    if(dato.anio = anio) then begin //el anio existe y ya hice el primer leer()
        accesos_anuales :=0;
        aux.anio := dato.anio;
        writeln('Anio: ', anio);
        while(dato.anio = aux.anio) do begin //si es diferente el anio estoy al final del archivo o cambié de año //por anio
            accesos_mensuales :=0;
            aux.mes := dato.mes;
            writeln('   Mes: ', dato.mes);
            while (dato.anio = aux.anio) and (dato.mes = aux.mes) do begin //por mes
                accesos_diarios := 0;
                aux.dia := dato.dia;
                writeln('       Dia: ', dato.dia);
                while (dato.anio = aux.anio) and (dato.mes = aux.mes) and (dato.dia = aux.dia) do begin //por dia
                    accesos_usuario := 0;
                    aux.idUs := dato.idUs;
                    while (dato.anio = aux.anio) and (dato.mes = aux.mes) and (dato.dia = aux.dia) and (dato.idUs = aux.idUs) do begin //por usuario
                        accesos_usuario += dato.tiempoAc;
                        leer(arc_maestro, dato);
                    end;
                    writeln('           idUsuario ', aux.idUs, ' Tiempo total de accesos en el dia ', aux.dia, ' mes ', aux.mes, ': ', accesos_usuario:2:2); //como me fui del while, dato ya no tiene lo que analizo, por lo cual debo mostrar la info del aux
                    accesos_diarios += accesos_usuario;
                end;
                writeln('       Tiempo total de accesos dia ', aux.dia, ' mes ', aux.mes, ': ', accesos_diarios:2:2);
                writeln('');
                accesos_mensuales += accesos_diarios;
            end;
            writeln('   Tiempo total de accesos mes ', aux.mes, ': ', accesos_mensuales:2:2);
            writeln('');
            accesos_anuales += accesos_mensuales;
        end;
        writeln('Tiempo total de accesos anio ', dato.anio, ': ', accesos_anuales:2:2);
        writeln('');
    end;

end;

var
arc_maestro:maestro;
anio:a;

begin
	Assign (arc_maestro,'maestro');
	write ('INGRESE ANIO: ');
	readln(anio);
	writeln ('');
	mostrarReporte (arc_maestro,anio);
end.