namespace Proximity {   
    class OutOfBandDisplay : Gtk.Grid {
        private ApplicationWindow application_window;

        public OutOfBandDisplay(ApplicationWindow application_window) {
            this.application_window = application_window;
            margin = 18;

            row_spacing = 6;
            column_spacing = 12;
        }

        public void render_interaction (Json.Array data_packets) {
            reset_state ();

            Json.Object? request_packet = null;
            Json.Object? response_packet = null;

            for (int i = 0; i < data_packets.get_length (); i++) {
                var packet = data_packets.get_element (i).get_object ();

                if (packet == null) {
                    continue;
                }

                if (!packet.has_member ("Direction")) {
                    continue;
                }

                if (packet.get_string_member ("Direction") == "Request") {
                    request_packet = packet;
                } else {
                    response_packet = packet;
                }
            }

            if (request_packet == null || response_packet == null) {
                return;
            }

            var row = 0;

            var parser = new Json.Parser ();
            try {
                if (!parser.load_from_data (request_packet.get_string_member ("DisplayData"), -1)) {
                    return;
                }

                var root = parser.get_root ();
                if (root == null && root.get_object () == null) {
                    return;
                }

                var request_root = root.get_object ();
                request_root.foreach_member ( (object, name, value) => {
                    var str_val = value.get_string ();
                    if (str_val == null || str_val == "") {
                        return;
                    }

                    var label_name = new Gtk.Label (name + ":");
                    var label_value = new Gtk.Label (str_val);

                    label_name.valign = Gtk.Align.START;
                    label_name.halign = Gtk.Align.END;
                    label_value.valign = Gtk.Align.START;
                    label_value.halign = Gtk.Align.START;

                    this.attach (label_name, 0, row, 1, 1);
                    this.attach (label_value, 1, row, 1, 1);

                    label_name.show ();
                    label_value.show ();

                    row++;
                });
            } catch {
            }

            var request_label = new Gtk.Label ("Request:");
            request_label.valign = Gtk.Align.START;
            request_label.halign = Gtk.Align.END;
            this.attach (request_label, 0, row, 1, 1);
            var request_data = Base64.decode(request_packet.get_string_member ("Data"));
            var request_text_view = new RequestTextView (application_window);
            request_text_view.scroll = false;
            request_text_view.set_request (request_data);
            this.attach (request_text_view, 1, row, 1, 1);

            request_label.show ();
            request_text_view.show ();

            row++;

            var response_label = new Gtk.Label ("Response:");
            response_label.valign = Gtk.Align.START;
            response_label.halign = Gtk.Align.END;
            this.attach (response_label, 0, row, 1, 1);
            var response_data = Base64.decode(response_packet.get_string_member ("Data"));
            var response_text_view = new RequestTextView (application_window);
            response_text_view.scroll = false;
            response_text_view.set_request (response_data);
            this.attach (response_text_view, 1, row, 1, 1);

            response_label.show ();
            response_text_view.show ();

            this.show ();
            
        }

        public void reset_state () {
            var children = get_children ();
            foreach (var child in children) {
                child.destroy ();
            }
        }
    }
}
