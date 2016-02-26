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

xmg:generate_instr(eq(v(Var),c(ID))):--
	decls::tget(Var,GV),
	code::enq((GV=ID)),
	!.

xmg:generate_instr(eq(c(ID),v(Var))):--
	decls::tget(Var,GV),
	code::enq((ID=GV)),
	!.

%% Useless, but should not be an error
xmg:generate_instr(eq(c(ID),c(ID1))):--
	code::enq((ID=ID1)),
	!.

%% xmg:generate_instr(eq(c(ID),v(Var))):--
%% 	decls::tget(Var,GV),
%% 	code::enq((GV=ID)),
%% !.

