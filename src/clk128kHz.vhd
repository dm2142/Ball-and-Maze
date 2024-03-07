library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.NUMERIC_STD.ALL;


entity clk128kHz is		
	 port(
		 CLK : 		in STD_LOGIC;	--	Reloj maestro
		 RST : 		in STD_LOGIC;	--	Reset maestro
		 CLK_OUT: 	out STD_LOGIC	--	Base de tiempo
	     );
end clk128kHz;


architecture Behavioral of clk128kHz is

	signal clk_out_s: STD_LOGIC := '0';	-- Se�al para trabajar con el divisor de frecuencia
    signal counter 	: integer range 0 to 194 := 0;	-- Ceunta m�xima para producir una frecuencia de 128 kHZ a partir de una de 50 MHz
	
begin
	
	CLK_OUT <= clk_out_s; -- Enviar la se�al a la salida.
	
	Frequency_divider: process (RST, CLK) begin
		if ( RST = '1') then
            clk_out_s <= '0';
            counter   <= 0;
        elsif rising_edge( CLK ) then	-- Cuando se presente un flanco de subida (cada 20 ns)
            if (counter = 194) then					
				clk_out_s <= NOT( clk_out_s );	-- Invertir se�al
                counter  <= 0;					-- Reiniciar la cuenta
            else
                counter <= counter + 1;	-- Permanecer la cuenta ascendente				
            end if;
        end if;
    end process;    
			
end Behavioral;