<#function mappedMCItemToIngameItemName mappedBlock>
    <#if mappedBlock.getUnmappedValue().startsWith("CUSTOM:")>
        <#assign customelement = generator.getRegistryNameForModElement(mappedBlock.getUnmappedValue())!""/>
        <#if customelement?has_content>
            <#return "\"item\": \"" + "${modid}:" + customelement
            + transformExtension(mappedBlock)
            + "\"">
        <#else>
            <#return "\"item\": \"minecraft:air\"">
        </#if>
    <#elseif mappedBlock.getUnmappedValue().startsWith("TAG:")>
        <#return "\"tag\": \"" + mappedBlock.getUnmappedValue().replace("TAG:", "")?lower_case + "\"">
    <#else>
        <#assign mapped = generator.map(mappedBlock.getUnmappedValue(), "blocksitems", 0) />
        <#if mapped.startsWith("#")>
            <#return "\"tag\": \"" + mapped.replace("#", "") + "\"">
        <#elseif mapped.contains(":")>
            <#return "\"item\": \"" + mapped + "\"">
        <#else>
            <#return "\"item\": \"minecraft:" + mapped + "\"">
        </#if>
    </#if>
</#function>

<#function mappedMCItemToIngameNameNoTags mappedBlock>
    <#if mappedBlock.getUnmappedValue().startsWith("TAG:")>
        <#return "minecraft:air">
    <#else>
        <#assign mapped = generator.map(mappedBlock.getUnmappedValue(), "blocksitems", 0) />
        <#if mapped.startsWith("#")>
            <#return "minecraft:air">
        <#elseif mapped.contains(":")>
            <#return mapped>
        <#else>
            <#return "minecraft:" + mapped>
        </#if>
    </#if>
</#function>

<#function mappedMCItemToBlockStateJSON mappedBlock>
    <#if mappedBlock.getUnmappedValue().startsWith("CUSTOM:")>
        <#assign mcitemresourcepath = mappedMCItemToIngameNameNoTags(mappedBlock)/>
        <#assign ge = w.getWorkspace().getModElementByName(mappedBlock.getUnmappedValue())/>
        <#if ge??>
            <#assign ge = ge.getGeneratableElement() />

            <#assign properties = []>
            <#if ge.getModElement().getType().getRegistryName() == "fluid">
                <#assign properties += [{"name": "level", "value": 0}] />
            <#elseif ge.getModElement().getType().getRegistryName() == "plant">
                <#if ge.plantType == "growapable">
                    <#assign properties += [{"name": "age", "value": 0}] />
                <#elseif ge.plantType == "double">
                    <#assign properties += [{"name": "half", "value": "lower"}] />
                </#if>
            <#elseif ge.getModElement().getType().getRegistryName() == "block">
                <#if ge.blockBase?has_content && ge.blockBase == "Stairs">
                    <#assign properties += [
                    {"name": "facing", "value": "north"},
                    {"name": "half", "value": "bottom"},
                    {"name": "shape", "value": "straight"},
                    {"name": "waterlogged", "value": "false"}
                    ] />
                <#elseif ge.blockBase?has_content && ge.blockBase == "Slab">
                    <#assign properties += [
                    {"name": "type", "value": "bottom"},
                    {"name": "waterlogged", "value": "false"}
                    ] />
                <#elseif ge.blockBase?has_content && ge.blockBase == "Fence">
                    <#assign properties += [
                    {"name": "east", "value": "false"},
                    {"name": "north", "value": "false"},
                    {"name": "south", "value": "false"},
                    {"name": "waterlogged", "value": "false"},
                    {"name": "west", "value": "false"}
                    ] />
                <#elseif ge.blockBase?has_content && ge.blockBase == "Wall">
                    <#assign properties += [
                    {"name": "east", "value": "none"},
                    {"name": "north", "value": "none"},
                    {"name": "south", "value": "none"},
                    {"name": "up", "value": "true"},
                    {"name": "waterlogged", "value": "false"},
                    {"name": "west", "value": "none"}
                    ] />
                <#elseif ge.blockBase?has_content && ge.blockBase == "Leaves">
                    <#assign properties += [
                    {"name": "distance", "value": "7"},
                    {"name": "persistent", "value": "false"}
                    ] />
                <#elseif ge.blockBase?has_content && ge.blockBase == "TrapDoor">
                    <#assign properties += [
                    {"name": "facing", "value": "north"},
                    {"name": "half", "value": "bottom"},
                    {"name": "open", "value": "false"},
                    {"name": "powered", "value": "false"},
                    {"name": "waterlogged", "value": "false"}
                    ] />
                <#elseif ge.blockBase?has_content && ge.blockBase == "Pane">
                    <#assign properties += [
                    {"name": "east", "value": "false"},
                    {"name": "north", "value": "false"},
                    {"name": "south", "value": "false"},
                    {"name": "waterlogged", "value": "false"},
                    {"name": "west", "value": "false"}
                    ] />
                <#elseif ge.blockBase?has_content && ge.blockBase == "Door">
                    <#assign properties += [
                    {"name": "facing", "value": "north"},
                    {"name": "half", "value": "lower"},
                    {"name": "hinge", "value": "left"},
                    {"name": "open", "value": "false"},
                    {"name": "powered", "value": "false"}
                    ] />
                <#elseif ge.blockBase?has_content && ge.blockBase == "FenceGate">
                    <#assign properties += [
                    {"name": "facing", "value": "north"},
                    {"name": "in_wall", "value": "false"},
                    {"name": "open", "value": "false"},
                    {"name": "powered", "value": "false"}
                    ] />
                <#else>
                    <#if ge.isWaterloggable>
                        <#assign properties += [{"name": "waterlogged", "value": "false"}] />
                    </#if>

                    <#if ge.rotationMode != 0 && ge.rotationMode != 5>
                        <#assign properties += [{"name": "facing", "value": "north"}] />
                    <#elseif ge.rotationMode == 5>
                        <#assign properties += [{"name": "axis", "value": "y"}] />
                    </#if>
                </#if>
            </#if>

            <#if properties?has_content>
                <#assign retval='{ "Name": "' + mcitemresourcepath + '", "Properties" : {'/>
                <#list properties as property>
                    <#assign retval = retval + '"' + property.name + '": "' + property.value + '"'/>
                    <#if property?has_next>
                        <#assign  retval = retval + ","/>
                    </#if>
                </#list>
                <#return retval + "} }">
            <#else>
                <#return '{ "Name": "' + mcitemresourcepath + '" }'>
            </#if>
        </#if>
    <#elseif !mappedBlock.getUnmappedValue().startsWith("TAG:")>
        <#assign mapped = generator.map(mappedBlock.getUnmappedValue(), "blocksitems", 0) />
        <#if !mapped.startsWith("#")>
            <#if !mapped.contains(":")>
                <#assign mapped = "minecraft:" + mapped />
            </#if>
            <#assign propertymap = fp.file("utils/defaultstates.json")?eval/>
            <#if propertymap[mapped]?has_content>
                <#assign retval='{ "Name": "' + mapped + '", "Properties" : {'/>
                <#list propertymap[mapped] as property>
                    <#assign retval = retval + '"' + property.name + '": "' + property.value + '"'/>
                    <#if property?has_next>
                        <#assign  retval = retval + ","/>
                    </#if>
                </#list>
                <#return retval + "} }">
            <#else>
                <#return '{ "Name": "' + mapped + '" }'>
            </#if>
        </#if>
    </#if>
    <#return '{ "Name": "minecraft:air" }'>
</#function>

<#function transformExtension mappedBlock>
    <#return (mappedBlock.toString().contains(".helmet"))?then("_helmet", "")
    + (mappedBlock.toString().contains(".body"))?then("_chestplate", "")
    + (mappedBlock.toString().contains(".legs"))?then("_leggings", "")
    + (mappedBlock.toString().contains(".boots"))?then("_boots", "")
    + (mappedBlock.toString().contains(".bucket"))?then("_bucket", "")>
</#function>
