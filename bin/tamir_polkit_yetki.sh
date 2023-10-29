#!/bin/sh
mkdir -p /etc/polkit-1/rules.d/
echo '
polkit.addRule(function(action, subject) {
   if (subject.isInGroup ("wheel")) {
       return polkit.Result.YES;
    }
});
' > /etc/polkit-1/rules.d/10-wheels.rules
