library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;


-- Contador gen�rico de 0 a 9 que se actualiza con cada flanco de subida de la Base de Tiempo.

entity Contador9 is		
	 port(
		 CLK 		: in STD_LOGIC;							--	Entrada de la Base de Tiempo.
		 RST 		: in STD_LOGIC;							--	Reset maestro.
		 COUNT 		: out STD_LOGIC_VECTOR(3 downto 0)		--	Salida con la cuenta actual 0 a 9 (Para llevar a un BCD to 7 segm.)
	     );
end Contador9;


architecture simple of Contador9 is
signal Qp,Qn : STD_LOGIC_VECTOR(3 downto 0):=(others =>'0');	--	Estado presente y siguiente del contador

begin				
	
	COUNT <= Qp;
	
	Mux: process( Qp ) is
	begin
		case Qp is
			when "0000" => 
				Qn <= "0001";
			when "0001" =>
				Qn <= "0010";
			when "0010" => 
				Qn <= "0011";
			when "0011" =>
				Qn <= "0100";
			when "0100" => 
				Qn <= "0101";
			when "0101" =>
				Qn <= "0110";
			when "0110" => 
				Qn <= "0111";
			when "0111" =>
				Qn <= "1000";
			when "1000" => 
				Qn <= "1001";
			when "1001" =>
				Qn <= "0000";
			when others => 
				Qn <= Qp;
		end case;
	end process Mux;
	
	Actualizador: process(CLK, RST,Qn) is		--	Proceso para actualizar el valor del estado presente con cada flanco de subida de la Base de Tiempo.
	begin		   
		if RST = '1' then
			Qp <= (others=>'0');
		elsif rising_edge( CLK ) then
			Qp <= Qn; 
		end if;
	end process Actualizador;

end simple;