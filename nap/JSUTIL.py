# -*- coding: utf-8 -*-

import requests
import numpy as np
import string, json

class jsutils(object):

    def __init__(self):
        pass

    def getJSforPredicates(self, terms):
        return self._getJSfor(terms, 'Predicates')

    def getJSforConcepts(self, terms):
        return self._getJSfor(terms, 'Concepts')


    def _getJSfor(self, terms, divname):

        terms.sort()

        options_all = ''
        for t in terms:
            options_all += '''<option value='%s'>%s</option>''' % (t,t)

        js = """
                container.show();
                var kernel = IPython.notebook.kernel;
                var otherstring = $("<div><h2>%s</h2><select size=10 style='width:400px;' id='%s' multiple='multiple'>%s</select></div>");
                element.append(otherstring);

                """ % (divname, divname, options_all)

        return js        

    def getJScallback(self, call_back_array, divname):

        js = """
        var kernel = IPython.notebook.kernel;
        $("#%s").change(function(e){
            console.log($("#%s").val());
            kernel.execute("%s=" + JSON.stringify($("#%s").val()))

        });
        """ % (divname, divname, call_back_array, divname)

        return js


    def getJSbuilder(self, selectedfields):

        options_all = ''
        for field in selectedfields:
            options_all += '''%s <input type='text' name='%s'/><input type='checkbox' name='check-%s' value='check-%s'><br>''' % (field,field, field, field)

        js = """
            container.show();

            var kernel = IPython.notebook.kernel;
            console.log('hahah');
            var otherstring = $("<div>%s</div>");
            element.append(otherstring);

        """ % (options_all)
        return js




