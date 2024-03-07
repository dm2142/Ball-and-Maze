library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.NUMERIC_STD.all;


entity Generic_Clock is
	generic(			
			X: integer:= 249980		--	N�mero m�ximo a pulsos a contar de acuerdo al divisor de frecuencia.
 	 	    );
	 port(
		 CLK : 		in std_logic;	--	Reloj maestro
		 RST : 		in std_logic;	--	Reset maestro
		 H	 :		in std_logic;	--  Habilitador del reloj
		 CLK_OUT: 	out std_logic 	--	Base de tiempo
	     );
end Generic_Clock;

-- Generar una se�al de reloj de 100 Hz (10 ms)

architecture Behavioral of Generic_Clock is

	signal clk_out_s: STD_LOGIC := '0';	-- Se�al para trabajar con el divisor de frecuencia
    signal counter 	: integer range 0 to X := 0;	-- Ceunta m�xima para producir una frecuencia de 100 HZ a partir de una de 50 MHz
	
begin
	
	CLK_OUT <= clk_out_s; -- Enviar la se�al a la salida.
	
	Frequency_divider: process (RST, H, CLK) begin
		if ( RST = '1') then
            clk_out_s <= '0';
            counter   <= 0;
		elsif( H = '0') then
			clk_out_s <= '0';
			counter <= counter;			-- Parar la cuenta en el n�mero que se quedo.
        elsif rising_edge( CLK ) then	-- Cuando se presente un flanco de subida (cada 20 ns)
            if (counter = X) then					
				clk_out_s <= NOT( clk_out_s );	-- Invertir se�al
                counter  <= 0;					-- Reiniciar la cuenta
            else
                counter <= counter + 1;	-- Permanecer la cuenta ascendente				
            end if;
        end if;
    end process;    
			
end Behavioral;