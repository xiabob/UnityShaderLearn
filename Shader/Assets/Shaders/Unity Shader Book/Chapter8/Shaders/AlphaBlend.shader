Shader "Unity Shader Book/Chapter 8/AlphaBlend"
{
    Properties
    {
        _Color ("Tint Color", Color) = (1, 1, 1, 1)
        _MainTex ("Main Texture", 2D) = "white" { }
        _AlphaScale ("Alpha Scale", Range(0, 1)) = 1
    }
    
    SubShader
    {
        Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
        
        Pass
        {
            ZWrite On
            ColorMask 0
        }
        
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"
            #include "UnityCG.cginc"
            
            fixed4 _Color;
            sampler2D _MainTex;
            fixed4 _MainTex_ST;
            fixed _AlphaScale;
            
            struct a2v
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
                fixed4 texcoord: TEXCOORD0;
            };
            
            struct v2f
            {
                float4 pos: SV_POSITION;
                float3 worldPos: TEXCOORD0;
                float3 worldNormal: NORMAL;
                fixed2 uv: TEXCOORD1;
            };
            
            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }
            
            fixed4 frag(v2f i): SV_TARGET
            {
                fixed3 worldPos = normalize(i.worldPos);
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = UnityWorldSpaceLightDir(i.worldPos);
                
                fixed4 texColor = tex2D(_MainTex, i.uv);
                fixed3 albedo = texColor.rgb * _Color.rgb;
                
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * albedo;
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, worldLightDir));
                
                return fixed4(ambient + diffuse, texColor.a * _AlphaScale);
            }
            
            ENDCG
            
        }
    }
    
    Fallback "Transparent/VertexLit"
}
