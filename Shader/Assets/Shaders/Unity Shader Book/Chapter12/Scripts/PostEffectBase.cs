using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode, RequireComponent(typeof(Camera))]
public class PostEffectBase : MonoBehaviour
{

    private void Start()
    {
        CheckResources();
    }

    protected virtual void CheckResources()
    {
        this.enabled = IsPostEffectSupport();
    }

    protected virtual bool IsPostEffectSupport()
    {
        return SystemInfo.supportsImageEffects && SystemInfo.supportsRenderTextures;
    }

    protected virtual Material CreateMaterialByShader(Shader shader, Material existMaterial)
    {
        if (!shader)
        {
            return null;
        }

        if (!shader.isSupported)
        {
            return null;
        }

        if (existMaterial != null && existMaterial.shader.Equals(shader))
        {
            return existMaterial;
        }

        Material mat = new Material(shader);
        if (mat != null)
        {
            mat.hideFlags = HideFlags.DontSave;
        }
        return mat;
    }

}
