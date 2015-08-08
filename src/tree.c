#include <stdlib.h>
#include <stdio.h>
#include "tree.h"

#define eprintf(args...) fprintf (stderr, args)

tree tree_make(enum tree_type type)
{
    tree ret = calloc(sizeof(*ret), 1);
    ret->type = type;
    return ret;
}

static const char *tree_type_string(enum tree_type t)
 {
    switch (t) {
        #define DEFTYPE(ETYPE, DESC)    \
            case ETYPE:                 \
                return #ETYPE;
        #include "tree.def"
        #undef DEFTYPE
        default:
            return "unknown";
    }
}

static void tree_print_indent(int depth)
{
    int i;
    for (i = 0; i < depth *2; i++)
        eprintf(" ");
}

void tree_dump(tree tree, int depth)
{
    while (tree) {
        tree_print_indent(depth);
        eprintf("<tree at %p, next %p, type %s,",
                tree, tree->next, tree_type_string(tree->type));
        switch (tree->type) {
        case T_INTEGER:
            gmp_fprintf(stderr, " number %Zd", tree->data.integer);
            break;
        case T_P_INC:
            eprintf(" exp:\n");
            tree_dump(tree->data.exp, depth + 1);
            break;
        }
        eprintf(">\n");
        tree = tree->next;
    }
}
