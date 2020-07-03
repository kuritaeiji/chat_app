import Vue from 'vue'
import { localize, extend } from 'vee-validate'
import ja from 'vee-validate/dist/locale/ja.json'

import * as rules from 'vee-validate/dist/rules'
for (let rule in rules) {
  extend(rule, rules[rule]);
}

localize('ja', ja)