export default {
    mounted() {
        const elmAppName = this.el.dataset.elmApp;

        if(!elmAppName) return;

        const flags = this.el.dataset.flags;

        const app = flags === undefined
            ? Elm[elmAppName].init({ node: this.el })
            : Elm[elmAppName].init({ node: this.el, flags})
            ;

        const ports = this.el.dataset.ports;

        if(ports)
            app.ports.pushEvent.subscribe((payload) => {
                this.pushEvent("elmex", payload);
            });
    }
};
