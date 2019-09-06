using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Chapter12_Luminance : PostEffectBase
{
    [SerializeField] private Shader m_Shader;
    [SerializeField] private float m_LuminanceThreshold = 0.5f;

    private Material m_ShaderMaterial;
    public Material ShaderMaterial
    {
        get
        {
            m_ShaderMaterial = CreateMaterialByShader(m_Shader, m_ShaderMaterial);
            return m_ShaderMaterial;
        }
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (ShaderMaterial != null)
        {
            ShaderMaterial.SetFloat("_LuminanceThreshold", m_LuminanceThreshold);
            Graphics.Blit(src, dest, ShaderMaterial);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}
