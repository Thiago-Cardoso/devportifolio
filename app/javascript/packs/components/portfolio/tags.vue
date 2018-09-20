<template>
  <div class="row">
    <div class="input-field col s12">
      <input type="text" id="autocomplete-tags" class="autocomplete" @keydown.enter="addTag">
      <label for="autocomplete-tags">Procure uma Tag</label>
    </div>
    <div class="col s12">
      <div class="chip" v-for="tag in portfolioTags" v-bind:key="tag">
        {{ tag.title }}
        <i class="close material-icons" @click="removeTag(tag)">close</i>
      </div>
    </div>
  </div>
</template>

<script>
 
export default {
  props: ['portfolioId', 'portfolioTags'],
 
  data() {
    return {
      currentTag: "",
      tags: []
    }
  },
 
  mounted() {
    this.$resource('/tags').get() //search in controller tag
        .then(response => { this.set_tags(response.body.tags) },
              response => { M.toast({ html: "Ocorreu um erro ao carregar as Tags do Portfólio", classes: "red" })
        })
  },
 
  methods: {
    set_tags(tags){
      let autoCompleteTags = {} //clean list autocomplete
      let elem = document.querySelectorAll('#autocomplete-tags') //get element id autocomplete-tags
      tags.forEach((tag) => { autoCompleteTags[tag.title] = null })
      this.tags = tags
      M.Autocomplete.init(elem, { data: autoCompleteTags });// call method complet materialize
    },
 
    addTag(event) {
        //find tag inside list of tag
      let tagToAdd = this.tags.find((tag) => { return tag.title == event.target.value })
      if(tagToAdd != "" && tagToAdd != null)
      {
        this.$resource('/portfolios{/portfolioId}/tags').save({ portfolioId: this.portfolioId }, { tag_id: tagToAdd.id })
            .then(
              response => {
                this.portfolioTags.push(tagToAdd)// add in list of tag
                event.target.value = ""
              },
              response => { response.body.errors.forEach(error => { M.toast({ html: error, classes: "red" }) }) }
            )
      }
    },
 
    removeTag(tag){
        //get list of tag and indexOf get position tag in array
      let indexToRemove = this.tags.indexOf(tag)
      this.$resource('/portfolios{/portfolioId}/tags{/tagId}').remove({ portfolioId: this.portfolioId, tagId: tag.id })
          .then(
            response => { this.portfolioTags.slice(indexToRemove, 1) }, //slice remove tag of array
            response => { response.body.errors.forEach(error => { M.toast({ html: error, classes: "red" }) }) }
          )
    }
  }
}
 
</script>