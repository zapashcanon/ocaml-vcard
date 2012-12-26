(*
 * Copyright (c) 2012 Vincent Bernardoff <vb@luminar.eu.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

%{
open Ast
%}

%token<string> ID
%token BEGIN_VCARD END_VCARD DQUOTE COMMA SEMI COLON EQUAL CRLF EOF

%start <Ast.vcard list> vcards

%%

vcards:
| vs = vcard+ EOF { vs }

vcard:
| BEGIN_VCARD CRLF cls = contentline+ END_VCARD CRLF { cls }

contentline:
| name = ID ps = param* COLON value = ID CRLF
    { { name; params=ps; value } }

param:
| SEMI id = ID EQUAL pv = param_value pvs = param_opt* { id, pv::pvs }

param_opt:
| COMMA pv = param_value { pv }

param_value:
| v = ID { v }
| DQUOTE v = ID DQUOTE { v }