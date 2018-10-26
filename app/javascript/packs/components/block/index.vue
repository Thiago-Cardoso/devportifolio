<template>
  <div class="row">
    <div class="col m10 offset-m1 s12">
      <div class="row">
        <div class="col s12">
          <h5 class="custom-grey-text page-title">Cards do Portfolio</h5>
        </div>
 
        <div class="col l4 m4 s12">
          <draggable v-model="leftBlocks" @end="updateBlocks(leftBlocks)">
            <div v-for="block in leftBlocks" :key="block.id" class="card-panel">
              <a class="fa fa-times grey-text right" @click="removeBlock(block)"></a>
              <component :is="block.kind" :portfolioId="portfolioId" :blockId="block.id"></component>
            </div>
          </draggable>
            
            <div class="card-panel center">
              <img src="/add_portfolio.png" id="add-left-block" @click="openModalToAdd('left')" />
            </div>
        </div>
 
        <div class="col l8 m8 s12">
          <draggable v-model="rightBlocks" @end="updateBlocks(rightBlocks)">
            <div v-for="block in rightBlocks" :key="block.id" class="card-panel">
              <a class="fa fa-times grey-text right" @click="removeBlock(block)"></a>
              <component :is="block.kind" :portfolioId="portfolioId" :blockId="block.id"></component>
            </div>
          </draggable>

            <div class="card-panel center">
              <img src="/add_portfolio.png" id="add-right-block" @click="openModalToAdd('right')" />
            </div>
        </div>
 
        <div id="add-block-modal" class="modal">
          <div class="modal-content">
            <h4>Adicionar Novo Bloco</h4>
            <div class="row">
              <div class="input-field col xl12 l12 m12 s12">
                <select v-model="blockToAdd.kind" class="browser-default" id="select-block-kind">
                  <option value="">Escolha um tipo</option>
                  <option v-for="(value, key) in blockKinds" :value="key" v-bind:key="key">{{ value }}</option>
                </select>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <a class="modal-close btn custom-grey">Cancelar</a>
            <a class="btn custom-green" id="confirm-add-block" @click="addBlock(blockToAdd)">Adicionar</a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
 
 
<script>
  import draggable from 'vuedraggable'

  import Profile from '../portfolio_resources/profile'
  import Education from '../portfolio_resources/education'
  import AdditionalInformation from '../portfolio_resources/additional_information'
  import About from '../portfolio_resources/about'
  import Contact from '../portfolio_resources/contact'
  import Experience from '../portfolio_resources/experience'
  import Hobby from '../portfolio_resources/hobby'
  import Language from '../portfolio_resources/language'
  import Skill from '../portfolio_resources/skill'
  import Social from '../portfolio_resources/social'
  import ContactForm from '../portfolio_resources/contact_form'  
 
  export default {
      components: {
        draggable,
        Profile,
        Education,
        'additional_information': AdditionalInformation,
        'contact_form': ContactForm,
        About,
        Contact,
        Experience,
        Hobby,
        Language,
        Skill,
        Social
    },
    data() {
      return {
        portfolioId: "",
        blocks: [],
        leftBlocks: [],
        rightBlocks: [],
        blockToAdd: { kind: "" },
        blockKinds: {},
        leftKinds: {
          profile: "Perfil",
          about: "Sobre mim",
          contact: "Contato",
          social: "Social",
          additional_information: "Informações Adicionais"
        },
        rightKinds: {
          experience: "Experiencia",
          education: "Educação",
          skill: "Habilidade",
          hobby: "Hobby",
          language: "Linguagem",
          additional_information: "Informações Adicionais",
          contact_form: "Formulário de contato"
        }
      }
    },
    watch: {
      blocks() {
          //fills list leftblock and rightblock
        this.leftBlocks = this.blocks.filter((block) => { return block.side == "left" })
        this.rightBlocks = this.blocks.filter((block) => { return block.side == "right" })
      }
    },

    created() {
      this.portfolioId = $("#portfolio-edit").data("portfolio"); // get id portfolio-edit
    },

    mounted(){
      let modal_element = document.getElementById("add-block-modal"); //select add-block-modal
      this.modalInstance = M.Modal.init(modal_element);// instance modal in materialize
      this.$resource('/portfolios{/portfolioId}/blocks').get({ portfolioId: this.portfolioId })// download blocks
          .then(response => { this.blocks = response.body.blocks },
                response => { M.toast({ html: "Error on trying to get Blocks", classes: "red" })
          })
    },

    methods: {
      openModalToAdd(side) {
        this.blockToAdd.side = side //open modal and get params side
        this.blockKinds = this[`${side}Kinds`]// put in list of kids
        this.modalInstance.open(); //open modal
      },
     updateBlocks(blocks){
        let blocksToUpdate = blocks.map((block, index) => { return { id: block.id, position: index } })
        this.$http.patch(`/portfolios/${this.portfolioId}/blocks/positions`, { blocks: blocksToUpdate })
          .then(
            response => {},
            response => {
              if(response.body.old_blocks)
                this.blocks = response.body.old_blocks
              M.toast({ html: "Ocorreu um erro ao atualizar as posições dos blocos", classes: "red" })
            })
      },
      addBlock() {
          // call api and add block
        this.$resource('/portfolios{/portfolioId}/blocks').save({ portfolioId: this.portfolioId }, { block: this.blockToAdd })
            .then(response => {
              this.blocks.push(response.body.block)// put in list of block
              this.modalInstance.close() //close modal
              this.blockToAdd = {} //clean blockToAdd
            }, response => {
              response.body.errors.forEach(error => { M.toast({ html: error, classes: "red" }) })
            })
      },

      removeBlock(blockToRemove){
            // call api and pass id
        this.$resource('/portfolios{/portfolioId}/blocks{/id}').remove({ portfolioId: blockToRemove.portfolio_id, id: blockToRemove.id })
            .then(response => {
              let indexToRemove = this.blocks.indexOf(blockToRemove) //remove of list block
              this.blocks.splice(indexToRemove, 1); //discover position in array and remove
            }, response => {
              response.body.errors.forEach(error => { M.toast({ html: error, classes: "red" }) })
            })
      }
    }
  }

</script>