#include <Evas.h>
#include <parrot/parrot.h>

//Parrot_PMC hack_interp;

void
evas_cb_helper(Parrot_PMC user_data, Evas_Object *obj, void *event_info)
{
    //Parrot_PMC pobj = pmc_new(hack_interp, enum_class_UnManagedStruct);
    //Parrot_PMC pinfo = pmc_new(hack_interp, enum_class_UnManagedStruct);
    //Parrot_PMC hash = pmc_new(hack_interp, enum_class_Hash);

    Parrot_callback_C("oh noes", user_data);
}

Parrot_PMC make_evas_cb_helper(Parrot_Interp interp, Parrot_PMC sub, Parrot_PMC user_data, Parrot_String cb_signature)
{
    Parrot_PMC cb, cb_sig, sync;
    Parrot_String sc;
    //hack_interp = interp;
    /*
     * we stuff all the information into the user_data PMC and pass that
     * on to the external sub
     */
    PMC * const interp_pmc = VTABLE_get_pmc_keyed_int(interp, interp->iglobals,
            (INTVAL) IGLOBALS_INTERPRETER);

    if (PMC_IS_NULL(interp_pmc)) {
        fprintf(stderr,"Current interpreter is null!\n");
        fflush(stderr);
    }
    else {
        //Parrot_eprintf("");
    }
    /* be sure __LINE__ is consistent */
    sc = Parrot_str_new_constant(interp, "_interpreter");
    VTABLE_setprop(interp, user_data, sc, interp_pmc);
    sc = Parrot_str_new_constant(interp, "_sub");
    VTABLE_setprop(interp, user_data, sc, sub);
    sc = Parrot_str_new_constant(interp, "_synchronous");
    sync = pmc_new(interp, enum_class_Integer);
    VTABLE_set_integer_native(interp, sync, 1);
    VTABLE_setprop(interp, user_data, sc, sync);



    cb_sig = pmc_new(interp, enum_class_String);
    VTABLE_set_string_native(interp, cb_sig, cb_signature);
    sc = Parrot_str_new_constant(interp, "_signature");
    VTABLE_setprop(interp, user_data, sc, cb_sig);
    /*
     * We are going to be passing the user_data PMC to external code, but
     * it may go out of scope until the callback is called -- we don't know
     * for certain as we don't know when the callback will be called.
     * Therefore, to prevent the PMC from being destroyed by a GC sweep,
     * we need to anchor it.
     *
     */
    gc_register_pmc(interp, user_data);

    /*
     * Finally, the external lib awaits a function pointer.
     */
    cb = pmc_new(interp, enum_class_UnManagedStruct);
    VTABLE_set_pointer(interp, cb, F2DPTR(evas_cb_helper));
    gc_register_pmc(interp, cb);

    return cb;
}

