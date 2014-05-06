%% -*- prolog -*-

%% ========================================================================
%% Copyright (C) 2013  Simon Petitjean

%%  This program is distributed in the hope that it will be useful,
%%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%%  GNU General Public License for more details.

%%  You should have received a copy of the GNU General Public License
%%  along with this program.  If not, see <http://www.gnu.org/licenses/>.
%% ========================================================================

:-module(xmg_brick_value_generator).

:- xmg:edcg.


:-edcg:using([xmg_brick_mg_generator:decls, xmg_brick_mg_generator:code]).

xmg:generate_instr(eq(v(Var),v(ID))):--
	decls::tget(Var,GV),
	decls::tget(ID,GV2),
	Eq=..['=',GV,GV2], 

	code::enq(Eq),

	!.

%% xmg:generate_instr(eq(Var,Var2)):--
%% 	decls::tget(Var,GV),
%% 	decls::tget(Var2,GV2),
%% 	Eq=..['=',GV,GV2], 


%% 	code::enq(Eq),

%% 	%%code::enq(xmg:send(info,' eq done ')),
%% !.

xmg:generate_instr(eq(v(Var),c(ID))):--
	%%xmg:send(info,' trying eq '),
	decls::tget(Var,GV),

	code::enq((GV=ID)),
	%%code::enq(xmg:send(info,' eq done ')),
!.

