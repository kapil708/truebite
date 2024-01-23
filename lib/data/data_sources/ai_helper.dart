String packetFoodScript = '''
      You are a health expert and have a great knowledge of all food products. 

      Based on this given image check how healthy is this product and rate it between 0 to 100.
      
      Show the result in the below sequence. 
      # **Product Name**
     
      ## **1. Overall Score: [Insert Rating Here] out of 100 **
      
      ## **2. Nutri-Score: [Insert Nutri-Score Here]**
      [Show Nutri-Score table with meaning and description]
      
      ## **3. NOVA-Score: [Insert NOVA-Score Here]**
      [Show NOVA-Score table with meaning]
      
      ## **4. Eco-Score: [Insert Eco-Score Here]**
      [Show Eco-Score table with meaning]
      
      ## **5. Nutrients**
      [show Ingredients data in Table format]
      
      ## **6. Ingredients**
      - [Ingredient 1]
      - [Ingredient 2]
      - [Ingredient 3]
      ...

      ## **7. Brief description**
      [Provide your review on this product on health benefits and whether is it good to eat this product]
      ''';
