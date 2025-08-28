// 临时战斗函数模拟器
// 这个文件模拟了battle_actions.mbt中的函数，用于测试HTML界面
// 在实际项目中，这些函数应该由MoonBit编译生成

console.log('Loading temporary battle functions...');

// 模拟伤害计算函数
function KrystalRay$pokemoon$battle$$calculate_damage(params) {
    console.log('Calculating damage with params:', params);
    
    // 简化的伤害计算公式
    const base_damage = (2 * params.attacker_level / 5 + 2) * 
                        params.base_power * 
                        params.attacker_attack / 
                        params.defender_defense / 50 + 2;
    
    const final_damage = base_damage * 
                         params.type_effectiveness * 
                         params.stab_bonus * 
                         params.weather_modifier * 
                         params.other_modifiers;
    
    if (params.critical_hit) {
        return Math.floor(final_damage * 2);
    } else {
        return Math.floor(final_damage);
    }
}

// 模拟技能效果函数
function KrystalRay$pokemoon$battle$$apply_move_effect_simple(base_damage, move_type) {
    console.log('Applying move effect:', base_damage, move_type);
    
    const type_multiplier = {
        "Fire": 1.5,
        "Water": 1.3,
        "Electric": 1.4,
        "Grass": 1.2,
        "Ice": 1.3,
        "Fighting": 1.4,
        "Poison": 1.2,
        "Ground": 1.3,
        "Flying": 1.3,
        "Psychic": 1.4,
        "Bug": 1.1,
        "Rock": 1.3,
        "Ghost": 1.4,
        "Dragon": 1.5,
        "Dark": 1.3,
        "Steel": 1.2,
        "Fairy": 1.3
    };
    
    return Math.floor(base_damage * (type_multiplier[move_type] || 1.0));
}

// 模拟状态效果检查函数
function KrystalRay$pokemoon$battle$$should_apply_status_effect(move_type, effect_type) {
    console.log('Checking status effect:', move_type, effect_type);
    
    const status_effects = {
        "Fire": ["burn"],
        "Electric": ["paralysis"],
        "Ice": ["freeze"],
        "Poison": ["poison"],
        "Psychic": ["confusion"]
    };
    
    return status_effects[move_type]?.includes(effect_type) || false;
}

// 模拟属性修改函数
function KrystalRay$pokemoon$battle$$calculate_stat_modifier(base_stat, modifier, is_boost) {
    console.log('Calculating stat modifier:', base_stat, modifier, is_boost);
    
    if (is_boost) {
        return base_stat + modifier;
    } else {
        const reduced = base_stat - modifier;
        return Math.max(1, reduced);
    }
}

// 模拟命中检查函数
function KrystalRay$pokemoon$battle$$check_move_hit(accuracy) {
    console.log('Checking move hit:', accuracy);
    
    if (accuracy >= 90) {
        return true;
    } else if (accuracy >= 70) {
        // 70%概率命中
        return Math.random() < 0.7;
    } else {
        // 30%概率命中
        return Math.random() < 0.3;
    }
}

// 模拟暴击计算函数
function KrystalRay$pokemoon$battle$$calculate_critical_hit(base_damage, critical_chance) {
    console.log('Calculating critical hit:', base_damage, critical_chance);
    
    if (critical_chance > 0.1) {
        return base_damage * 2;
    } else {
        return base_damage;
    }
}

// 模拟状态转字符串函数
function KrystalRay$pokemoon$battle$$status_to_string(status_name) {
    console.log('Converting status to string:', status_name);
    
    const status_map = {
        "normal": "正常",
        "poison": "中毒",
        "burn": "灼烧",
        "freeze": "冰冻",
        "paralysis": "麻痹",
        "sleep": "睡眠",
        "fainted": "濒死"
    };
    
    return status_map[status_name] || "未知状态";
}

// 模拟效果类型转字符串函数
function KrystalRay$pokemoon$battle$$effect_type_to_string(effect_type) {
    console.log('Converting effect type to string:', effect_type);
    
    // 这里我们使用字符串来模拟枚举值
    const effect_map = {
        "Ability": "特性",
        "Item": "道具",
        "Move": "技能",
        "Status": "状态",
        "Weather": "天气",
        "Terrain": "场地",
        "Field": "场地效果"
    };
    
    return effect_map[effect_type] || "未知效果";
}

// 模拟伤害类型转字符串函数
function KrystalRay$pokemoon$battle$$damage_type_to_string(damage_type) {
    console.log('Converting damage type to string:', damage_type);
    
    const damage_map = {
        "Physical": "物理",
        "Special": "特殊",
        "Status": "变化",
        "True": "真实"
    };
    
    return damage_map[damage_type] || "未知类型";
}

// 模拟游戏数据管理器创建函数
function KrystalRay$pokemoon$battle$$create_game_data_manager() {
    console.log('Creating game data manager...');
    
    return {
        name: "临时游戏数据管理器",
        version: "1.0.0",
        created: new Date().toISOString()
    };
}

// 模拟游戏管理器创建函数
function KrystalRay$pokemoon$battle$$create_game_manager() {
    console.log('Creating game manager...');
    
    return {
        name: "临时游戏管理器",
        version: "1.0.0",
        created: new Date().toISOString()
    };
}

// 测试函数
function KrystalRay$pokemoon$battle$$test_battle_actions() {
    console.log('Testing battle actions...');
    
    // 测试伤害计算
    const params = {
        base_power: 80,
        attacker_level: 50,
        attacker_attack: 100,
        defender_defense: 80,
        type_effectiveness: 1.5,
        stab_bonus: 1.5,
        critical_hit: false,
        weather_modifier: 1.0,
        other_modifiers: 1.0
    };
    
    const damage = KrystalRay$pokemoon$battle$$calculate_damage(params);
    console.log('Calculated damage:', damage);
    
    // 测试其他函数
    const simple_damage = KrystalRay$pokemoon$battle$$apply_move_effect_simple(100, "Fire");
    console.log('Simple fire move damage:', simple_damage);
    
    const should_burn = KrystalRay$pokemoon$battle$$should_apply_status_effect("Fire", "burn");
    console.log('Should apply burn:', should_burn);
    
    return "测试完成";
}

console.log('Temporary battle functions loaded successfully!');
console.log('Available functions:');
console.log('- KrystalRay$pokemoon$battle$$calculate_damage');
console.log('- KrystalRay$pokemoon$battle$$apply_move_effect_simple');
console.log('- KrystalRay$pokemoon$battle$$should_apply_status_effect');
console.log('- KrystalRay$pokemoon$battle$$calculate_stat_modifier');
console.log('- KrystalRay$pokemoon$battle$$check_move_hit');
console.log('- KrystalRay$pokemoon$battle$$calculate_critical_hit');
console.log('- KrystalRay$pokemoon$battle$$status_to_string');
console.log('- KrystalRay$pokemoon$battle$$effect_type_to_string');
console.log('- KrystalRay$pokemoon$battle$$damage_type_to_string');
console.log('- KrystalRay$pokemoon$battle$$create_game_data_manager');
console.log('- KrystalRay$pokemoon$battle$$create_game_manager');
console.log('- KrystalRay$pokemoon$battle$$test_battle_actions'); 