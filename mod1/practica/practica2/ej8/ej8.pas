CONST 
valorAlto =9999;

type

cliente = record
	cod:integer;
	NyA: string;
	anio: integer;
	mes: 1..12;
	dia: 1..31;
	montoV:real;
end;

maestro = file of cliente;

procedure imprimirCliente (c:cliente);
begin
	with c do begin
		writeln ('|CODIGO: ',cod);
		writeln ('|NOMBRE Y APELLIDO: ',NyA);
	end;
end;

procedure leer (var arc_maestro:maestro; var dato:cliente);
begin
	if not eof (arc_maestro) then
		read (arc_maestro,dato)
	else
		dato.cod:= valorAlto;
end;

procedure reporte (var arc_maestro: maestro);
var
    cli, aux: cliente;
    monto_total, monto_anual, monto_mensual: real;
begin
    reset(arc_maestro);
    monto_total:=0;
    leer(arc_maestro, cli);
    while (cli.cod <> valorAlto) do begin //para cada cliente
        aux.cod := cli.cod;
        writeln('cliente: ', aux.cod);
        while(aux.cod = cli.cod) do begin //mientras siga en el mismo cliente
            monto_anual:=0;
            aux.anio := cli.anio;
            while(aux.cod = cli.cod) and (aux.anio = cli.anio) do begin //mientras siga en el mismo anio
                monto_mensual := 0;
                aux.mes := cli.mes;
                while (aux.cod = cli.cod) and (aux.anio = cli.anio) and (aux.mes = cli.mes) do begin //mientras siga en el mismo mes
                    monto_mensual += cli.montoV;
                    leer(arc_maestro, cli); //no olvidar que en el menor bucle debo avanzar

                end;
                if monto_mensual > 0 then
                    writeln('mes: ', aux.mes, ', gastos: ', monto_mensual:0:2);
                monto_anual += monto_mensual;
            end;
            writeln('anio: ', aux.anio, ', gastos: ', monto_anual:0:2);
            monto_total += monto_anual;
        end;
        //acá podría decir el monto total del cliente actual
    end;
    writeln('gastos totales de la empresa: ', monto_total:0:2);

    close(arc_maestro);
end;

var
    arc_maestro: maestro;

begin
    assign(arc_maestro, 'maestro');
    writeln('Reporte de la empresa: ');
    reporte(arc_maestro);
end.