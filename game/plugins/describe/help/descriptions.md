Every character, room and exit has a description that tells you what you see when you look at it.

   %xcdescribe <name>=<description>%xn
   %xcdescribe/edit <name>%xn - Grabs the existing description into your input 
       buffer (if your client supports it.  See %xhhelp edit%xn.)
       
You can set a shorter description that is used whenever an at-a-glance description is needed.

   %xcshortdesc <name>=<description>%xn
   %xcshortdesc/edit <name>%xn - Grabs the existing description into your input 
       buffer (if your client supports it.  See %xhhelp edit%xn.)

You can also have multiple outfits for your character, and have more detailed views that are separate from your main description.  See:

    %xhhelp outfits%xn
    %xhhelp details%xn

The %xhlook%xn command is used to look around.

   %xclook <name>%xn
   %xclook%xn  (shortcut for looking at 'here')
   %xclook <name>/<detail>%xn - Looks at a detail on something.