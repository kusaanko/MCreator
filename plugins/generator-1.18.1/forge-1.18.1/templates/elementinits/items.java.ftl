<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2021, Pylo, opensource contributors
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 # Additional permission for code generator templates (*.ftl files)
 #
 # As a special exception, you may create a larger work that contains part or
 # all of the MCreator code generator templates (*.ftl files) and distribute
 # that work under terms of your choice, so long as that work isn't itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;

<#assign hasBlocks = false>

@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD) public class ${JavaModName}Items {

    private static final List<Item> REGISTRY = new ArrayList<>();

    <#list items as item>
        <#if item.getModElement().getTypeString() == "armor">
            <#if item.enableHelmet>
            public static final Item ${item.getModElement().getRegistryNameUpper()}_HELMET = register(new ${item.getModElement().getName()}Item.Helmet());
            </#if>
            <#if item.enableBody>
            public static final Item ${item.getModElement().getRegistryNameUpper()}_CHESTPLATE = register(new ${item.getModElement().getName()}Item.Chestplate());
            </#if>
            <#if item.enableLeggings>
            public static final Item ${item.getModElement().getRegistryNameUpper()}_LEGGINGS = register(new ${item.getModElement().getName()}Item.Leggings());
            </#if>
            <#if item.enableBoots>
            public static final Item ${item.getModElement().getRegistryNameUpper()}_BOOTS = register(new ${item.getModElement().getName()}Item.Boots());
            </#if>
        <#else>
            public static final Item ${item.getModElement().getRegistryNameUpper()} = register(new ${item.getModElement().getName()}Item());
        </#if>
    </#list>

    private static Item register(Item item) {
		REGISTRY.add(item);
    	return item;
    }

	@SubscribeEvent public static void registerItems(RegistryEvent.Register<Item> event) {
		event.getRegistry().registerAll(REGISTRY.toArray(new Item[0]));
	}

}

<#-- @formatter:on -->