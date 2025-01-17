
// Special AI/pAI PDAs that cannot explode.
/obj/item/device/pda/ai
	icon_state = "NONE"
	ttone = "data"
	detonate = 0


/obj/item/device/pda/ai/proc/set_name_and_job(newname as text, newjob as text, newrank as null|text)
	owner = newname
	ownjob = newjob
	if(newrank)
		ownrank = newrank
	else
		ownrank = ownjob
	name = newname + " (" + ownjob + ")"

//AI verb and proc for sending PDA messages.
/obj/item/device/pda/ai/verb/cmd_send_pdamesg()
	set category = "AI IM"
	set name = "Send PDA Message"
	set src in usr

	if(!can_use())
		return
	var/datum/data/pda/app/messenger/M = find_program(/datum/data/pda/app/messenger)
	if(!M)
		to_chat(usr, "<span class='warning'>Cannot use messenger!</span>")
	var/list/plist = M.available_pdas()
	if(plist)
		var/c = input(usr, "Please select a PDA") as null|anything in sortList(plist)
		if(!c) // if the user hasn't selected a PDA file we can't send a message
			return
		var/selected = plist[c]
		M.create_message(usr, selected)

/obj/item/device/pda/ai/verb/cmd_toggle_pda_receiver()
	set category = "AI IM"
	set name = "Toggle Sender/Receiver"
	set src in usr

	if(!can_use(usr))
		return
	var/datum/data/pda/app/messenger/M = find_program(/datum/data/pda/app/messenger)
	M.toff = !M.toff
	to_chat(usr, "<span class='notice'>PDA sender/receiver toggled [(M.toff ? "Off" : "On")]!</span>")

/obj/item/device/pda/ai/verb/cmd_toggle_pda_silent()
	set category = "AI IM"
	set name = "Toggle Ringer"
	set src in usr

	if(!can_use())
		return
	var/datum/data/pda/app/messenger/M = find_program(/datum/data/pda/app/messenger)
	M.notify_silent = !M.notify_silent
	to_chat(usr, "<span class='notice'>PDA ringer toggled [(M.notify_silent ? "Off" : "On")]!</span>")

/obj/item/device/pda/ai/verb/cmd_show_message_log()
	set category = "AI IM"
	set name = "Show Message Log"
	set src in usr

	if(!can_use())
		return
	var/datum/data/pda/app/messenger/M = find_program(/datum/data/pda/app/messenger)
	if(!M)
		to_chat(usr, "<span class='warning'>Cannot use messenger!</span>")
	var/HTML = "<html><head><title>AI PDA Message Log</title></head><body>"
	for(var/index in M.tnote)
		if(index["sent"])
			HTML += addtext("<i><b>&rarr; To <a href='byond://?src=[REF(src)];choice=Message;target=",index["src"],"'>", index["owner"],"</a>:</b></i><br>", index["message"], "<br>")
		else
			HTML += addtext("<i><b>&larr; From <a href='byond://?src=[REF(src)];choice=Message;target=",index["target"],"'>", index["owner"],"</a>:</b></i><br>", index["message"], "<br>")
	HTML +="</body></html>"
	usr << browse(HTML, "window=log;size=400x444;border=1;can_resize=1;can_close=1;can_minimize=0")


/obj/item/device/pda/ai/can_use()
	return 1


/obj/item/device/pda/ai/attack_self(mob/user as mob)
	if ((honkamt > 0) && (prob(60)))//For clown virus.
		honkamt--
		playsound(src, 'sound/items/bikehorn.ogg', 30, 1)
	return


/obj/item/device/pda/ai/pai
	ttone = "assist"
	var/our_owner = null // Ref to a pAI
	touch_silent = TRUE
	programs = list(
		new/datum/data/pda/app/main_menu,
		new/datum/data/pda/app/notekeeper,
		new/datum/data/pda/app/messenger)

/obj/item/device/pda/ai/pai/Initialize()
	if(istype(loc, /mob/living/silicon/pai))
		our_owner = REF(loc)
	. = ..()

/obj/item/device/pda/ai/pai/tgui_status(mob/living/silicon/pai/user, datum/tgui_state/state)
	if(!istype(user) || REF(user) != our_owner) // Only allow our pAI to interface with us
		return STATUS_CLOSE
	return ..()

/obj/item/device/pda/ai/shell
	spam_proof = TRUE // Since empty shells get a functional PDA.
