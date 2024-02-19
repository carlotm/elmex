export default {
    mounted() {
        const elmAppName = this.el.dataset.elmApp;

        if(!elmAppName)
        {
            console.warn(`Please check if data-elm-app is correct for DOM element #${this.el.id}`);
            return;
        }
        Elm[elmAppName].init({ node: this.el });
    }
};
