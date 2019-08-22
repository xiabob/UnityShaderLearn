Shader "Unity Shader Book/Chapter6/Diffuse Vertex-Level"
{
    Properties
    {
        _Diffuse ("Diffuse", Color) = (0, 0, 0, 0)
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
            
            fixed4 _Diffuse;
            
            struct a2v
            {
                float4 position: POSITION;
                float3 normal: NORMAL;
            };
            
            struct v2f
            {
                float4 position: SV_POSITION;
                fixed3 color: COLOR0;
            };
            
            v2f vert(a2v i)
            {
                v2f o;
                
                //将顶点从模型空间转换到其次裁减空间
                o.position = UnityObjectToClipPos(i.position);
                
                //将发线向量从模型空间转换到世界空间（因为光线向量是世界空间）
                i.normal = UnityObjectToWorldNormal(i.normal);
                //归一化世界空间下的光线向量
                fixed3 worldLight = normalize(_WorldSpaceLightPos0);
                //计算漫反射
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * max(0, dot(i.normal, worldLight));
                //计算最终的颜色值：漫反射+环境光
                o.color = diffuse + UNITY_LIGHTMODEL_AMBIENT.rgb;
                
                return o;
            }
            
            fixed4 frag(v2f i): SV_TARGET
            {
                return fixed4(i.color, 1);
            }
            
            ENDCG
            
        }
    }

    Fallback "Diffuse"
}
