//= require_tree
//= require jquery
//= require jquery_ujs

require("jquery")
require("@nathanvda/cocoon")

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "bootstrap"



Rails.start()
Turbolinks.start()
ActiveStorage.start()

global.toastr = require("toastr")
