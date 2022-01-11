namespace Proximity {
    public interface MainApplicationPane : Object {
        public signal void pane_changed ();
        
        public virtual bool back_visible () {
            return false;
        }

        public virtual bool can_search () {
            return true;
        }

        public virtual string new_tooltip_text () {
            return "";
        }

        public virtual bool new_visible () {
            return false;
        }

        public virtual void on_back_clicked () {
        }

        public virtual void on_new_clicked () {
        }

        public virtual void on_search (string text, bool exclude_resources) {
        }

        public abstract void reset_state ();

        public virtual void set_selected_guid (string guid) {
        }
    }
}
