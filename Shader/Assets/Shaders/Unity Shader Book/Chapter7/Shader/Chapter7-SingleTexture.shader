Shader "Unity Shader Book/Chapter 7/Single Texture"
{
    Properties
    {
        _Color ("Tint Color", Color) = (1, 1, 1, 1)
        _MainTexture ("Main Texture", 2D) = "white" { }
        _Specular ("Specular", Color) = (1, 1, 1, 1)
        _Gloss ("Gloss", Range(8, 100)) = 20
    }
    
    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"
            #include "UnityCG.cginc"
            
            fixed4 _Color;
            sampler2D _MainTexture;
            float4 _MainTexture_ST;
            fixed4 _Specular;
            float _Gloss;
            
            struct a2v
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
                float4 texcoord: TEXCOORD0;
            };
            
            struct v2f
            {
                float4 position: SV_POSITION;
                float3 worldPosition: TEXCOORD1;
                float3 worldNormal: NORMAL;
                float2 uv: TEXCOORD2;
            };
            
            v2f vert(a2v i)
            {
                v2f o;
                o.position = UnityObjectToClipPos(i.vertex);
                o.worldPosition = mul(unity_ObjectToWorld, i.vertex);
                o.worldNormal = UnityObjectToWorldNormal(i.normal);
                o.uv = TRANSFORM_TEX(i.texcoord, _MainTexture);
                return o;
            }
            
            float4 frag(v2f i): SV_TARGET
            {
                fixed3 albedo = tex2D(_MainTexture, i.uv).rgb * _Color.rgb; 
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * albedo;
                
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLight = normalize(UnityWorldSpaceLightDir(i.worldPosition));
                fixed3 diffuse = albedo * _LightColor0.rgb * max(0, dot(worldNormal, worldLight));
                
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPosition));
                fixed3 halfDir = normalize(viewDir + worldLight);
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);
                
                fixed3 color = ambient + diffuse + specular;
                
                return fixed4(color, 1);
            }
            
            ENDCG
            
        }
    }
    
    Fallback "Diffuse"
}
