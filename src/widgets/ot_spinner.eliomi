(* Ocsigen Toolkit
 * http://www.ocsigen.org/ocsigen-toolkit
 *
 * Copyright (C) 2014
 *      Vincent Balat
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, with linking exception;
 * either version 2.1 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *)

[%%shared.start]

(** {2 Spinner widget} *)

val with_spinner
  :  ?a:[< Html_types.div_attrib] Eliom_content.Html.attrib list
  -> ?spinner:[< Html_types.div_content] Eliom_content.Html.elt list
  -> ?fail:(exn -> [< Html_types.div_content] Eliom_content.Html.elt list Lwt.t)
  -> [< Html_types.div_content] Eliom_content.Html.elt list Lwt.t
  -> [> `Div] Eliom_content.Html.elt Lwt.t
(** On client side, [with_spinner th] returns immediately a spinner
    while Lwt thread [th] is not finished, that will automatically
    be replaced by the result of [th] when finished.

    On server side, it will wait for [th] to be finished before
    returning its result (and never display a spinner).

    If you want the spinner on both sides, you can use [with_spinner_no_lwt]
    and [Eliom_content.Html.C.node].

    Function [fail] will be used to display block in case an exception is
    raised.

    Use optional argument [spinner] on client side to customize the spinner.
    By default it is a [div] element with classes
    [ot-icon-spinner] and [ot-icon-animation-spinning].
    (see default stylesheet).
 *)

[%%client.start]

val with_spinner_no_lwt
  :  ?a:[< Html_types.div_attrib] Eliom_content.Html.attrib list
  -> ?spinner:[< Html_types.div_content] Eliom_content.Html.elt list
  -> ?fail:(exn -> [< Html_types.div_content] Eliom_content.Html.elt list)
  -> [< Html_types.div_content] Eliom_content.Html.elt list Lwt.t
  -> [> `Div] Eliom_content.Html.elt
(** Same as [with_spinner] but returns immediately.
    Client only (as we must wait for the thread to terminate on server
    before sending the page). *)

val replace_content
  :  ?fail:(exn -> [< Html_types.div_content] Eliom_content.Html.elt list Lwt.t)
  -> 'a Eliom_content.Html.elt
  -> Html_types.div_content Eliom_content.Html.elt list Lwt.t
  -> unit Lwt.t
(** [replace_content elt thread] replaces the contents of [elt] by the content
    generated by [thread]. The [elt] has be a D-node. Until [thread] is
    finished [elt] is transformed into a spinner. *)

val num_active_spinners : int Eliom_shared.React.S.t
(** the number of spinners currently spinning *)

val onloaded : unit Eliom_shared.React.E.t
(**  [onloaded] is an event that fires when all spinners have finished loading.
    This can occur multiple times. *)

val when_loaded : (unit -> unit) -> unit
(**  do an action once no spinners are spinning (could be right away) *)

val set_default_fail
  :  (exn -> [< Html_types.div_content] Eliom_content.Html.elt list)
  -> unit
(** Change the default function used to display error messages *)
